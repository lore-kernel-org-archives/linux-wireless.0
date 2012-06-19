Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42376 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab2FSJjG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 05:39:06 -0400
Received: by mail-ob0-f174.google.com with SMTP id tb18so9789205obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2012 02:39:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FE03291.5030202@cern.ch>
References: <4FE03291.5030202@cern.ch>
Date: Tue, 19 Jun 2012 15:09:06 +0530
Message-ID: <CAD2nsn1U0UHjrDp7vh7rfvTP=BLB3FA+zLV9sgt1_T7gVvAYgg@mail.gmail.com> (sfid-20120619_113911_507772_1854C09D)
Subject: Re: Mysterious hangs - cfg80211 - ath9k
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Jon Wikne <Jon.Wikne@cern.ch>
Cc: linux-wireless@vger.kernel.org, wikne@cheetah.uio.no
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 19, 2012 at 1:34 PM, Jon Wikne <Jon.Wikne@cern.ch> wrote:
> Hi List,
>
> I am experiencing a puzzling problem with WLAN on a Toshiba Qosmio
> F750 laptop, running CERN SLC 5.8 (mostly identical to RHEL 5.8),
> but with kernel 2.6.39.4. (The kernel that came with the distro did
> not work properly with WLAN on this machine at all.)

please quickly try
http://linuxwireless.org/en/users/Download#Where_to_download_bleeding_edge

or the latest wireless testing tree
http://linuxwireless.org/en/developers/Documentation/git-guide#Cloning_latest_wireless-testing

>
> What happens is that the WLAN comes up flawlessly, and works well
> until it suddenly hangs. This happens when (or seconds after) I see
> an entry like the following in the log:
>
> Jun 18 19:04:42 redcat kernel: cfg80211: Calling CRDA to update world
> regulatory domain
>
> I do not understand why cfg80211 does this long after the connection
> has been established. If I understand correctly, this "regulatory
> domain" business only makes sense when the WLAN interface is started.
>
> Subsequent DHCP requests are issued, but never answered:
>
> Jun 18 19:23:38 redcat dhclient: DHCPREQUEST on wlan0 to 137.138.16.6 port
> 67 (xid=0x63998557)
> Jun 18 19:24:16 redcat last message repeated 3 times
> Jun 18 19:25:30 redcat last message repeated 6 times
> .....
> Jun 18 19:50:10 redcat dhclient: DHCPREQUEST on wlan0 to 255.255.255.255
> port 67 (xid=0x63998557)
> Jun 18 19:50:55 redcat last message repeated 3 times
> .....
> Jun 18 19:58:41 redcat dhclient: No DHCPOFFERS received.
>
> I interpret this as something has (effectively) been turned off,
> but that the drivers do not realize this.
>
> Restarting WLAN when the problem has occurred is simple:
>
> root@redcat 97 # /sbin/ifdown wlan0
> root@redcat 98 # /sbin/ifup wlan0
>
> What puzzles me even more is that cfg80211 seems to be activated
> and mess up things at highly irregular intervals, ranging from
> a few minutes to many hours:
>
> root@redcat 105 # tail -2000l /var/log/messages | grep cfg80211
> Jun 17 20:28:51 redcat kernel: cfg80211: Calling CRDA to update world
> regulatory domain
> Jun 17 23:09:37 redcat kernel: cfg80211: Calling CRDA to update world
> regulatory domain
> Jun 17 23:36:01 redcat kernel: cfg80211: Calling CRDA to update world
> regulatory domain
> Jun 18 09:27:59 redcat kernel: cfg80211: Calling CRDA to update world
> regulatory domain
> Jun 18 11:57:48 redcat kernel: cfg80211: Calling CRDA to update world
> regulatory domain
> Jun 18 18:42:00 redcat kernel: cfg80211: Calling CRDA to update world
> regulatory domain
> Jun 18 18:46:49 redcat kernel: cfg80211: Calling CRDA to update world
> regulatory domain
> Jun 18 19:04:42 redcat kernel: cfg80211: Calling CRDA to update world
> regulatory domain
> Jun 18 22:40:42 redcat kernel: cfg80211: Calling CRDA to update world
> regulatory domain
>
> At the time of writing this (Tue 19 Jun 2012 09:27:54 CEST) the WLAN
> has not stopped since the last entry in the above. What on earth is
> governing the timing in this?
>
> Some relevant info on the laptop:
>
> root@redcat 108 # lspci
> .....
> 03:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless
> Network Adapter (PCI-Express) (rev 01)
> .....
>
> root@redcat 109 # lsmod
> Module                  Size  Used by
> .....
> ath9k                  89934  0
> mac80211              160999  1 ath9k
> ath9k_common            3051  1 ath9k
> .....
> ath9k_hw              291258  2 ath9k,ath9k_common
> ath                    15289  2 ath9k,ath9k_hw
> .....
> cfg80211              141299  3 ath9k,mac80211,ath
>
> Any ideas will be greatly appreciated. I will be happy to test
> patches. Please CC me at jon.wikne@cern.ch since I am not on
> the list.
>
>
> Regards,
> -- Jon Wikne
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi
