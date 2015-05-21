Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34138 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503AbbEUHoK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 03:44:10 -0400
Received: by wghq2 with SMTP id q2so76544184wgh.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 May 2015 00:44:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1432127990.19214.14.camel@sipsolutions.net>
References: <1432039021-29666-1-git-send-email-michal.kazior@tieto.com>
	<1432127874.19214.13.camel@sipsolutions.net>
	<1432127990.19214.14.camel@sipsolutions.net>
Date: Thu, 21 May 2015 09:44:09 +0200
Message-ID: <CA+BoTQmyY35mY_CVVK7kDr=DTaLLyATo20nB34es7Q=dTSEDCQ@mail.gmail.com> (sfid-20150521_094416_242852_CBFD6CFA)
Subject: Re: [PATCH 1/2] cfg80211: ignore netif running state when changing iftype
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 May 2015 at 15:19, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2015-05-20 at 15:17 +0200, Johannes Berg wrote:
>
>> > -   if (ntype != otype && netif_running(dev)) {
>> > +   if (ntype != otype) {
>> >             dev->ieee80211_ptr->use_4addr = false;
>> >             dev->ieee80211_ptr->mesh_id_up_len = 0;
>> >             wdev_lock(dev->ieee80211_ptr);
>>
>> I don't think that makes much sense - the code within this block really
>> only makes sense when the interface *is* running, like disconnecting
>> etc. Doing that when it's *not* would be entirely unexpected to the
>> drivers, no?

The netif_running() was originally introduced in f8cdddb8d61d which
did in for entirely different purpose. Hence stripping netif_running()
shouldn't be a problem for drivers, can it? The patch was also made
kind of obsolete by b6a550156bc. Perhaps there are some other
behavioral changes that I'm unaware of in stuff that gets called upon
entering this condition down the stack..?

Maybe it's just safer to move use_4addr/mesh_id_up_len clearing into a
separate `oftype != ntype` condition. What do you think?


> The real problem here might be the assignment to use_4addr *before*
> we've actually disconnected or anything, perhaps that should be moved?
>
> Similarly, the mesh_id_up_len should probably be moved into the mesh
> point switch case...

The problem isn't use_4addr clearing ordering per se. The problem is
it wasn't cleared at all on interface changes. The minimal subset of
commands that would crash the system was:

  # host A and host B have just booted; no wpa_s/hostapd running; all
vifs are down
  host A> iw wlan0 set type station
  host A> iw wlan0 set 4addr on
  host A> printf
'interface=wlan0\nssid=4addrcrash\nchannel=1\nwds_sta=1' > /tmp/hconf
  host A> hostapd -B /tmp/conf
  host B> iw wlan0 set 4addr on
  host B> ifconfig wlan0 up
  host B> iw wlan0 connect -w hostAssid
  host A> pkill hostapd
  # host A crashes:

[  127.928192] BUG: unable to handle kernel NULL pointer dereference
at 00000000000006c8
[  127.929014] IP: [<ffffffff816f4f32>] __sta_info_flush+0xac/0x158
...
[  127.934578]  [<ffffffff8170789e>] ieee80211_stop_ap+0x139/0x26c
[  127.934578]  [<ffffffff8100498f>] ? dump_trace+0x279/0x28a
[  127.934578]  [<ffffffff816dc661>] __cfg80211_stop_ap+0x84/0x191
[  127.934578]  [<ffffffff816dc7ad>] cfg80211_stop_ap+0x3f/0x58
[  127.934578]  [<ffffffff816c5ad6>] nl80211_stop_ap+0x1b/0x1d
[  127.934578]  [<ffffffff815e53f8>] genl_family_rcv_msg+0x259/0x2b5

; gdb vmlinux -ex 'l * __sta_info_flush+0xac' -ex quit --quiet
Reading symbols from vmlinux...done.
0xffffffff816f4f32 is in __sta_info_flush
(/devel/src/linux/net/mac80211/sta_info.c:1033).
1028     WARN_ON(vlans && !sdata->bss);
1029
1030     mutex_lock(&local->sta_mtx);
1031     list_for_each_entry_safe(sta, tmp, &local->sta_list, list) {
1032           if (sdata == sta->sdata ||
1033               (vlans && sdata->bss == sta->sdata->bss)) {
1034            if (!WARN_ON(__sta_info_destroy_part1(sta)))
1035                    list_add(&sta->free_list, &free_list);
1036            ret++;
1037           }

This is because:

(cfg.c, ieee80211_change_station)
  1397                  if (params->vlan->ieee80211_ptr->use_4addr) {
  1398                          if (vlansdata->u.vlan.sta) {
  1399                                  err = -EBUSY;
  1400                                  goto out_err;
  1401                          }
  1402
  1403                          rcu_assign_pointer(vlansdata->u.vlan.sta, sta);
  1404                          new_4addr = true;
  1405                  }
  1406

@1397 would eval to true even though vlansdata is IFTYPE_AP.
u.vlan.sta has identical memory offset as u.ap.next_beacon. During
ieee80211_stop_ap() it would:

(cfg.c, ieee80211_stop_ap)
   913          kfree(sdata->u.ap.next_beacon);
   914          sdata->u.ap.next_beacon = NULL;
...
   929          __sta_info_flush(sdata, true);

Effectively sta_info was freed at @914 and then __sta_info_flush()
tried to use it (after it was freed).

Do you want me to put the above into the commit log? Should I put a
copy into the mac80211 patch as well?


Michał
