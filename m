Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f50.google.com ([209.85.216.50]:43011 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab3BQVVK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Feb 2013 16:21:10 -0500
Received: by mail-qa0-f50.google.com with SMTP id dx4so1015781qab.9
        for <linux-wireless@vger.kernel.org>; Sun, 17 Feb 2013 13:21:09 -0800 (PST)
Message-ID: <512149C2.8020208@lwfinger.net> (sfid-20130217_222121_992229_B774C1DD)
Date: Sun, 17 Feb 2013 15:21:06 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Malinen, Jouni" <jouni@qca.qualcomm.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Regression caused by commit df88129
References: <8887AA04B7EC49479420AE48C5F94A93017ACD48@NASANEXD02D.na.qualcomm.com>
In-Reply-To: <8887AA04B7EC49479420AE48C5F94A93017ACD48@NASANEXD02D.na.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/17/2013 08:41 AM, Malinen, Jouni wrote:
>
>
> On 2/17/13 8:31 AM, "Larry Finger" <Larry.Finger@lwfinger.net> wrote:
>
>> IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
>> wlan0: dropped frame to c0:3f:0e:be:2b:44 (unauthorized port)
>
> I do see one of these (which, I'd assume, is actually expected if you
> have something on the system that runs to transmit before 4-way
> handshake is completed).

I also have seen one of these for some time.

>> wlan0: dropped frame to c0:3f:0e:be:2b:44 (unauthorized port)
>> wlan0: dropped frame to c0:3f:0e:be:2b:44 (unauthorized port)
>
> But this does not show up in my tests with mac80211_hwsim and the
> current wireless-testing.git and hostap.git snapshots.
>
>> The regression was bisected to commit
>> df881293c6ba9a12868491a717b25cb14ec1fa4a.
>
> Did you confirm that the latest snapshot works with this reverted?

With the commit reverted, the latest kernel-wireless version works.

>> If you need any more debugging output for this problem, please let me
>> know.
>
> Since I was unable to reproduce, some more debug output could be
> useful. Please at least verify that the STA entry for the AP is not
> marked authorized. The next step would be to check whether sta_set_flags
> in wpa_supplicant driver_nl80211.c is failing. Unfortunately, it looks
> like the current implementation does not make this very clear in the
> debug log, so some additional prints may be needed there.

Just to be clear, b43 is used as a station, not as AP. The card I am using has a 
G PHY. I added printk statements for every setting of 'authorized' in 
net/mac80211/tx.c. It is set false at line 1984, thus 'multicast' is false. 
Furthermore, sta is not NULL, but WLAN_STA_AUTHORIZED is not set in the sta 
flags. Note: sta->_flags is 0x60023.

Although sdata->vif.type is set to 2 (NL80211_IFTYPE_STATION), variable 
'authorized' was not touched at line 1908, thus "sdata->wdev.wiphy->flags & 
WIPHY_FLAG_SUPPORTS_TDLS" is false. The content of sdata->wdev.wiphy->flags is 
0x1401f8.

> Please also describe the security configuration (WPA2-Personal/CCMP?)
> that you are using.

I'm running openSUSE 12.3 RC1, which has version 1.1 of wpa_supplicant. The 
router is a Netgear WNDR3300 running standard firmware and set for WPA2-PSK(AES) 
encryption.

Checking with newer versions of the supplicant is being a problem. I built both 
2.0 from the tarball and 2.1-devel from the git repo, but nether will run with 
NetworkManager. I will see if I can resolve that problem later.

Thanks,

Larry



