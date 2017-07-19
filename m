Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:40646 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S933121AbdGSTZg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Jul 2017 15:25:36 -0400
Subject: Re: brcmfmac bus level addressing issues.
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        brcm80211-dev-list@broadcom.com,
        Hante Meuleman <hante.meuleman@broadcom.com>
References: <aacfa1fd-ac34-b3c1-b078-4b6a5eefe4ca@mnementh.co.uk>
 <87cdbbc12b504e89d2bd1c33df6a6bf6@mail.gmail.com>
 <5eb895bd-58cf-70fd-3c00-c8fed86aed79@mnementh.co.uk>
 <6fe08666ca09bf3c1d4476fdad8ce97a@mail.gmail.com>
 <222e2bc1-4d8f-8133-4fa7-51a48f3de785@mnementh.co.uk>
 <0395e3f6-6bd9-cbad-0fe2-9a5d32a9baa6@mnementh.co.uk>
 <701af0be-87b6-a397-ae29-a5ba75605588@broadcom.com>
 <feb0cba3-27da-6cab-316f-164867867cd6@mnementh.co.uk>
 <126c9c73-387e-e718-5ac8-e816ec922989@broadcom.com>
From: Ian Molton <ian@mnementh.co.uk>
Message-ID: <184bdea1-5c6b-d022-ffd0-fc19b19829b4@mnementh.co.uk> (sfid-20170719_212540_542280_70E55F08)
Date: Wed, 19 Jul 2017 20:25:33 +0100
MIME-Version: 1.0
In-Reply-To: <126c9c73-387e-e718-5ac8-e816ec922989@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19/07/17 12:47, Arend van Spriel wrote:
> On 19-07-17 00:45, Ian Molton wrote:

>> (as it stands, back to back wpasuplpicant runs make it keel over, as
>> does module unload and reload).
> 
> It is good to get such feedback. We should get in details about this.

I'll reply with a couple of logs on here. I was going to just post the
one, but of course, typically, it did not fail the same way this time...

# rmmod brcmfmac

brcmfmac: brcmf_proto_bcdc_query_dcmd: brcmf_proto_bcdc_msg failed
w/status -5
brcmfmac: brcmf_cfg80211_get_tx_power: error (-5)
brcmfmac: brcmf_fil_cmd_data: bus is down. we have nothing to do.
brcmfmac: brcmf_link_down: WLC_DISASSOC failed (-5)
brcmfmac: brcmf_fil_cmd_data: bus is down. we have nothing to do.
brcmfmac: brcmf_fil_cmd_data: bus is down. we have nothing to do.
brcmfmac: brcmf_fil_cmd_data: bus is down. we have nothing to do.
brcmfmac: brcmf_cfg80211_get_channel: chanspec failed (-5)
Enter

# modprobe brcmfmac
 [1 ] core 0x800:49 base 0x18000000 wrap 0x18100000
 [2 ] core 0x812:39 base 0x18001000 wrap 0x18101000
 [3 ] core 0x829:21 base 0x18002000 wrap 0x18102000
 [4 ] core 0x82a:9  base 0x18003000 wrap 0x18103000
 [5 ] core 0x80e:22 base 0x18004000 wrap 0x18104000
 [6 ] core 0x135:0  base 0x00000000 wrap 0x18105000
 [7 ] core 0x240:0  base 0x00000000 wrap 0x18106000
Enter
RAM: base=0x0 size=524288 (0x80000) sr=65536 (0x10000)
Found BCM43430, AXI backplane, rev=1
ccrev=49, pmurev=24, pmucaps=0x39d25f18
Enter
Enter
Enter
Enter
brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Aug 29 2016
20:48:16 version 7.45.41.26 (r640327) FWID 01-4527cfab
IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready

#
# wpa_supplicant -B -i wlan0 -c <(wpa_passphrase vortex24 password) &&
dhclient wlan0

Successfully initialized wpa_supplicant
rfkill: Cannot open RFKILL control device
brcmfmac: brcmf_link_down: WLC_DISASSOC failed (-11)
rfkill: Cannot open RFKILL control device
brcmfmac: brcmf_cfg80211_escan: Connecting: status (3)
brcmfmac: brcmf_cfg80211_scan: scan error (-11)

# wget --no-check-certificate
https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.12.tar.xz
--2017-07-19 19:13:22--
https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.12.tar.xz
Resolving cdn.kernel.org (cdn.kernel.org)... 151.101.17.176,
2a04:4e42:4::432
Connecting to cdn.kernel.org (cdn.kernel.org)|151.101.17.176|:443...
connected.
WARNING: The certificate of ‘cdn.kernel.org’ is not trusted.
WARNING: The certificate of ‘cdn.kernel.org’ hasn't got a known issuer.
HTTP request sent, awaiting response... 200 OK
Length: 99186576 (95M) [application/x-xz]
Saving to: ‘linux-4.12.tar.xz.30’

linux-4.12.tar.xz.3   1%[                    ]   1.81M  1.08MB/s
      ^C
root@martel:~# brcmfmac: brcmf_cfg80211_escan: Connecting: status (3)
brcmfmac: brcmf_cfg80211_scan: scan error (-11)

# wget --no-check-certificate
https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.12.tar.xz
--2017-07-19 19:15:01--
https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.12.tar.xz
Resolving cdn.kernel.org (cdn.kernel.org)...
<never completed>

brcmfmac: brcmf_cfg80211_escan: Connecting: status (3)
brcmfmac: brcmf_cfg80211_scan: scan error (-11)
brcmfmac: brcmf_cfg80211_escan: Scanning already: status (1)
brcmfmac: brcmf_cfg80211_scan: scan error (-11)
brcmfmac: brcmf_cfg80211_escan: Connecting: status (3)
brcmfmac: brcmf_cfg80211_scan: scan error (-11)
brcmfmac: brcmf_cfg80211_escan: Connecting: status (3)
brcmfmac: brcmf_cfg80211_scan: scan error (-11)
