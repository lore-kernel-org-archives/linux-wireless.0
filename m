Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:47571 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab2GXLaV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2012 07:30:21 -0400
Received: by qcro28 with SMTP id o28so3745075qcr.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jul 2012 04:30:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <500BEA08.6020406@allnet.de>
References: <50082319.5060703@openwrt.org>
	<500BEA08.6020406@allnet.de>
Date: Tue, 24 Jul 2012 13:30:20 +0200
Message-ID: <CAGXE3d_Kq-j7mrFffpcJhGt0Np0p96BeAY_5S2A3aEj2uUwRvw@mail.gmail.com> (sfid-20120724_133046_884960_C5257B92)
Subject: Re: [rt2x00-users] rt2x00 and hostapd
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Daniel Golle <dgolle@allnet.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

On Sun, Jul 22, 2012 at 1:54 PM, Daniel Golle <dgolle@allnet.de> wrote:
> rt2x00 doesn't work with hostapd, the driver seems to wrongly interpret the
> carrier state and refuse to send beacons if there is no carrier.
> there is a workaround out there to fix this (see below), but the right way
> would be to have this done similar to other mac80211 driver which do not
> require this workaround.
> anyone got an idea what's wrong here?

Oh, wow, I haven't tried any recent compat-wireless snapshots but this seems
strange. The main question is if this is a hostapd issue or a rt2x00
issue but since
rt2x00 doesn't care about the carrier state AFAIK this seems odd to me ...

However, while looking through the code there are at least a few issues with
the current handling of configuration changes in rt2x00:

>From rt2x00mac.c:

        if (changes & (BSS_CHANGED_ERP_CTS_PROT |
BSS_CHANGED_ERP_PREAMBLE |
                       BSS_CHANGED_ERP_SLOT | BSS_CHANGED_BASIC_RATES
|
                       BSS_CHANGED_BEACON_INT | BSS_CHANGED_HT))
                rt2x00lib_config_erp(rt2x00dev, intf, bss_conf, changes);

So, even if the beacon int hasn't changed we will still configure it
to the device. This might
cause all sorts of issues.

So, it might make sense to split the rt2x00lib_config_erp call into
several calls for each
change-flag or to pass the changed flags to the necessary
sub-functions to not commit
false changes ...

However, I'm not sure if this is related to your problem but might be
an entry point for
you to track the problem down.

Helmut

> -------- Original Message --------
> Subject: Re: [OpenWrt-Devel] [PATCH] mac80211: import patch for rt2x00
> Date: Thu, 19 Jul 2012 17:09:13 +0200
> From: Felix Fietkau <nbd@openwrt.org>
> To: OpenWrt Development List <openwrt-devel@lists.openwrt.org>
> CC: Daniel Golle <dgolle@allnet.de>
>
> On 2012-07-19 5:02 PM, Daniel Golle wrote:
>> without this hostapd doesn't work on any of the RT3xxx systems I tested.
>>
>> Signed-off-by: Daniel Golle <dgolle@allnet.de> ---
>> ...10-rt2x00-mac80211-manage-AP-netdev-carrier-state.patch | 14
>> ++++++++++++++ 1 file changed, 14 insertions(+) create mode 100644
>> package/mac80211/patches/610-rt2x00-mac80211-manage-AP-netdev-carrier-state.patch
>>
>>
>>
> diff --git
>> a/package/mac80211/patches/610-rt2x00-mac80211-manage-AP-netdev-carrier-state.patch
>>
>>
> b/package/mac80211/patches/610-rt2x00-mac80211-manage-AP-netdev-carrier-state.patch
>>
>>
> new file mode 100644
>> index 0000000..a1d9f06 --- /dev/null +++
>> b/package/mac80211/patches/610-rt2x00-mac80211-manage-AP-netdev-carrier-state.patch
>>
>>
>>
> @@ -0,0 +1,14 @@
>> +Index: compat-wireless-2012-04-17/net/mac80211/iface.c
>> +=================================================================== +---
>> compat-wireless-2012-04-17.orig/net/mac80211/iface.c  2012-05-09
>> 01:00:39.197975402 +0200 ++++
>> compat-wireless-2012-04-17/net/mac80211/iface.c       2012-05-09
>> 01:02:32.514918371 +0200 +@@ -411,8 +407,7 @@ +
>> ieee80211_bss_info_change_notify(sdata, changed); + +                 if
>> (sdata->vif.type == NL80211_IFTYPE_STATION || +-                  sdata->vif.type ==
>> NL80211_IFTYPE_ADHOC || +-                sdata->vif.type == NL80211_IFTYPE_AP) ++
>> sdata->vif.type == NL80211_IFTYPE_ADHOC) +                    netif_carrier_off(dev); +
>> else +                        netif_carrier_on(dev);
> I think this needs to be sorted out upstream. As far as I know, nobody
> so far has figured out yet why managing the netdev carrier state causes
> the hostapd issues and why it appears to only happen on rt2x00.
>
> - Felix
>
>
>
>
> _______________________________________________
> users mailing list
> users@rt2x00.serialmonkey.com
> http://rt2x00.serialmonkey.com/mailman/listinfo/users_rt2x00.serialmonkey.com
