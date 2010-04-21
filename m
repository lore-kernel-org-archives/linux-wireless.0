Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:48221 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab0DUHGN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Apr 2010 03:06:13 -0400
Received: by wwb24 with SMTP id 24so3832928wwb.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Apr 2010 00:06:11 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1271782442.14052.19698.camel@rchatre-DESK>
References: <n2g2d0a357f1004170705j6d0750fdkc4784f86aab51c97@mail.gmail.com>
	 <1271782442.14052.19698.camel@rchatre-DESK>
Date: Wed, 21 Apr 2010 09:06:11 +0200
Message-ID: <s2j2d0a357f1004210006gc964e5edl672ec5406b892a9@mail.gmail.com>
Subject: Re: iwl3945: Error sending REPLY_{RXON|SCAN_CMD|TX_PWR_TABLE_CMD}
	time out after 500ms
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 20, 2010 at 6:54 PM, reinette chatre
<reinette.chatre@intel.com> wrote:
> Hi,
>
> On Sat, 2010-04-17 at 07:05 -0700, Sedat Dilek wrote:
>> I have already sent an bug-report "iwl3945: Network dropouts w/
>> flash-stream in firefox" in [1].
>> Unfortunately, the problem still remains, especially when
>> fast-forwarding flash movies in firefox-3.6.3.
>> It seems the wifi-card is hanging and my system needs a coldstart.
>
> Is this a recent problem? How regularly do you update your kernel?
>

Currently, I am using mostly upstream 2.6.34-rcX kernels.
When kernel snapshots (-gitX) have drm-2.6, ext4 or wireless-2.6
patches I jump on them.

>>
>> The kernel I use is a Linux-2.6.34-rc4-git4 with these 3 patches in addition:
>
> Where can I access this kernel's git repo?
>

As I already said it is Linus-tree - to be on 2.6.34-rc4-git4 [1], run:

$ git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
$ git reset --hard dc57da3875f527b1cc195ea4ce5bd32e1e68433d

It would be cool, when you can check this on some iwl3945 hardware.
Do not forget the three patches from [2] to have same testing environment.

As far as I can see, wireless-2.6 (master-2010-04-20) has them included.

>> According to Johannes (on IRC) iwl3945 doesn't use internal scans yet
>> (see my patch below).
>> Thus, I am not sure if this needs to be fixed separately for iwl3945
>> and if I ran into a scan race condition here.
>
> Does this patch make any difference for you?
>

Speaking of my patch "iwl3945-fix-scan-races.patch" from [3]?
I was guessing iwl3945 has internal scans support - is that the fact?
Johannes told me someone is working on it.

To answer your question: Not sure, but it seems not to help.
Unfortunately, it is hard for me to say what exactly caused these wifi problems.
After my email I tested 2.6.34-rc4-git6 and could not reproduce it.
I tested several websites with flash streams.

Do the ash particles of the Iceland volcano disturb wlan waves here?
Wonder why John gave no restrictions to Linux wireless users and devs
to not use wifi and switch to wired connections for last weekend and
next days :-).

>> Hope, this helps.
>
> It does. Thank you. As a sanity check, could you please try this patch?
>

In general, it would be very helpful to give some comments on what
this offered patch is doing.
Not sure, if I can test it today.

To have same scenario, base is a Linux-2.6.34-rc4-git4 kernel with this series:

wireless-2.6/0001-iwlwifi-work-around-bogus-active-chains-detection.patch
iwlwifi-fixes-for-2.6.34/1-2-iwlwifi-fix-scan-races.patch
iwlwifi-fixes-for-2.6.34/2-2-iwlwifi-correct-6000-EEPROM-regulatory-address.patch
rchatre/sanity-check.patch

> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index c8cd169..1ad15bd 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -814,7 +814,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata)
>        changed |= BSS_CHANGED_ASSOC;
>        sdata->vif.bss_conf.assoc = false;
>
> -       ieee80211_set_wmm_default(sdata);
> +       /*ieee80211_set_wmm_default(sdata);*/
>
>        /* channel(_type) changes are handled by ieee80211_hw_config */
>        local->oper_channel_type = NL80211_CHAN_NO_HT;
>

By the way, might help to set one of the module-options for iwl3945?

parm:           antenna:select antenna (1=Main, 2=Aux, default 0 [both]) (int)
parm:           swcrypto:using software crypto (default 1 [software]) (int)
parm:           debug:debug output mask (uint)
parm:           disable_hw_scan:disable hardware scanning (default 0) (int)
parm:           fw_restart3945:restart firmware in case of error (int)

Especially "fw_restart3945" in my case? On which errors it is
restarting firmware?

Kind Regards,
- Sedat -

[1] http://www.kernel.org/pub/linux/kernel/v2.6/snapshots/patch-2.6.34-rc4-git4.id
[2] http://files.iniza.org/BUG_iwl3945_20100417/patches/
[3] http://marc.info/?l=linux-wireless&m=127151315515173&w=2
