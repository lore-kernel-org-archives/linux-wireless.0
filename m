Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:54206 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbaAZLEO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jan 2014 06:04:14 -0500
Message-ID: <52E4EBAA.2010204@broadcom.com> (sfid-20140126_120418_032970_2A662AD1)
Date: Sun, 26 Jan 2014 12:04:10 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>, <linux-sunxi@googlegroups.com>
CC: Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Olliver Schinagl <oliver+list@schinagl.nl>,
	<benn@cubietech.com>,
	brcm80211-dev-list <brcm80211-dev-list@broadcom.com>
Subject: Re: [linux-sunxi] Firmware for Bluetooth (and wifi)
References: <52A040CE.5040706@schinagl.nl> <CAFXj5xjJ0DTa0Qo1avLboQF-e3TFv3aEr_jjkuZjinwuTzXykQ@mail.gmail.com> <52A09B5B.70800@schinagl.nl> <CAGRGNgWBgWqoPUdHSm2OXGb8r-ca5NX2z4_v0eG6oOMgJRd3HQ@mail.gmail.com> <52B17973.1000608@broadcom.com> <52B19F38.7060503@redhat.com> <52B1CA51.4010202@broadcom.com> <CAGb2v67cnP0yth0xxBKcaW_T2fF+4nP4r6h9NLqy5FV2x=hO=Q@mail.gmail.com> <CAGb2v67mmYnyPeOd4Wwp1zHs7EC_Gr+gEdaaMWeKP5z_Z_SVGA@mail.gmail.com> <CAGb2v66646-1Sye=Eb04_SoeCGBU064OePcxDi7th1fqU8XfBg@mail.gmail.com> <52BD68BA.3080304@broadcom.com> <CAGb2v67Q=q4vyOftb+BLhAYR-6d04dDP3+kY3b88U8_vCvAmgQ@mail.gmail.com> <52CD12D4.5030008@broadcom.com> <CAGb2v64+5Rgs6JxD0iH3bcwXPOm-xyS_LSmWLfx0qiMQwreOeQ@mail.gmail.com> <52E19A27.7000402@redhat.com> <52E23FB2.7010705@broadcom.com> <52E29607.8040102@redhat.com>
In-Reply-To: <52E29607.8040102@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/24/2014 05:34 PM, Hans de Goede wrote:
> Hi,
> 
> On 01/24/2014 11:25 AM, Arend van Spriel wrote:
>> On 01/23/2014 11:39 PM, Hans de Goede wrote:
>>> Hi,
>>>
>>> I've been working on updating sunxi-devel to include more
>>> recent versions if your gmac patches, as well as adding support
>>> for the wifi + bluetooth found on the cubietruck.
>>>
>>> Here is my current work on this:
>>>
>>> https://github.com/jwrdegoede/linux-sunxi/commits/sunxi-devel
>>>
>>> It is close to working, but unfortunately it does not work,
>>> here is what I get in dmesg when I modprove the module:
>>>
>>> [   99.700889] brcmfmac_sdio mmc1:0001:1: device tree node not found
>>> [  100.020984] brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0:
>>> Apr 22 2013 14:50:00 version 5.90.195.89.6 FWID 01-b30a427d
>>> [  100.260948] brcmfmac: brcmf_fil_cmd_data: Failed err=-23
>>> [  100.281260] brcmfmac: brcmf_fil_cmd_data: Failed err=-23
>>> [  100.322508] usbcore: registered new interface driver brcmfmac
>>> [  160.445215] brcmfmac: brcmf_cfg80211_sched_scan_start: Scanning
>>> already: status (1)
>>> [  203.445404] brcmfmac: brcmf_cfg80211_sched_scan_start: Scanning
>>> already: status (1)
>>> [  256.445140] brcmfmac: brcmf_cfg80211_sched_scan_start: Scanning
>>> already: status (1)
>>
>> Can you enable debug logging in brcmfmac, ie. debug=0xd416 so I can have
>> a look.
> 
> I've captured a log with these flags until the first "Scanning already"
> message, you can find it here:

Hi Hans,

The log looks confusing.

[  543.512827] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69)
ifidx 0 bsscfg 0 addr 02:00:00:00:00:00
[  543.512840] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0
status 0 reason 0
[  543.512849] brcmutil: event payload, len=12
[  543.512860] 00000000: 0c 00 00 00 6d 00 00 00 34 12 00 00
  ....m...4...
[  543.512872] brcmfmac: brcmf_inform_bss scanned AP count (0)
[  543.512880] brcmfmac: brcmf_notify_escan_complete Enter
[  543.512891] brcmfmac: brcmf_notify_escan_complete ESCAN Completed
scan: Done
[  543.512911] brcmfmac: brcmf_fil_iovar_data_set name=mpc, len=4
[  543.512919] brcmutil: data
[  543.512928] 00000000: 01 00 00 00
  ....
[  543.512941] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
[  543.512951] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[  543.513018] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter

The trace messages above indicate completion of regular scan and after
that the code does:

	if (!test_and_clear_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status))
		brcmf_dbg(SCAN, "Scan complete, probably P2P scan\n");

[  543.514758] brcmfmac: brcmf_cfg80211_sched_scan_start Enter
n_match_sets:0 n_ssids:0
[  543.514777] brcmfmac: brcmf_cfg80211_sched_scan_start: Scanning
already: status (1)

So the bit SCAN_STATUS_BUSY should be cleared, but you get this message.
That makes no sense to me or test_and_clear_bit() does something else
than I expect. Either way the scheduled scan request would be rejected
because it has 0 match_sets and ssids. Maybe this is intended to
indicate any AP is to be reported. Will look in cfg80211 whether that is
the case.

Regards,
Arend

