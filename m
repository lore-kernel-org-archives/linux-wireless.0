Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out04.msg.oleane.net ([62.161.7.2]:57142 "EHLO
        smtp-out04.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754135AbcLNSgy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Dec 2016 13:36:54 -0500
From: "Jean-Pierre Tosoni" <jp.tosoni@acksys.fr>
To: "'Ben Greear'" <greearb@candelatech.com>,
        <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
References: <004a01d24fe2$94da8dc0$be8fa940$@acksys.fr> <63c731f2-ee21-6450-2ae4-2808e7130eb5@candelatech.com>
In-Reply-To: <63c731f2-ee21-6450-2ae4-2808e7130eb5@candelatech.com>
Subject: RE: ath10k firmware sends probes on DFS channels without radar detection
Date: Wed, 14 Dec 2016 19:14:13 +0100
Message-ID: <00e701d25635$e0108480$a0318d80$@acksys.fr> (sfid-20161214_193658_272638_54C4E795)
MIME-Version: 1.0
Content-Type: text/plain;
        charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/06/15 08:36 PM, Ben Greear wrote: 
> On 12/06/2016 09:02 AM, Jean-Pierre Tosoni wrote:
> > This follows on the previous discussion
> > 	"Client station sends probes on DFS channels"
> >
> > Problem:
> > The combination of QCA988X firmware v10.2.4.70-2 + ath10k +
> > wpa_supplicant do not comply with the norm ETSI/EN 301-893 section
> > 4.7; because they can send probes for 600s when no AP is around.
> >
> > Analysis:
> > The problem seems to lie in the firmware, which regards the presence
> > of *any* beacon as a proof that the channel is radar-clean for 600s.
> >
> > This is a wrong hypothesis, since a rogue AP sending fraudulent
> > beacons should not induce a scrupulous STA in sending illegal probes.
> >
> > Moreover, the norm (table D.1) sets a time limit of 10s to shutdown
> > when no AP positively allows the STA to transmit on the DFS channel.
> >
> > Status:
> > - there is no known plan at QCA to fix the issue.
> > - ath10k firmware is not publicly available for fixes.
> > - there is no obvious fix working in ath10k.
> > - the issue does not show up with other mac80211 devices like ath9k.
> > - wpa_supplicant considers this is a kernel issue [2]
> 
> Have you confirmed that there are no probe requests being sent by ath10k
> driver?

I have put a printk in the ath10k_tx function (in the path for management
frames) and it does not show up.
On another hand I cannot find any other function preparing / sending probes.
There is only the wmi command that starts scans.

> 
> You could also try disabling the station keep-alive and roaming logic in
> the firmware by tweaking the wmi initial setup logic.  I disable that in
> my firmware, for instance, because mac80211 can do a better job and then I
> can save resources in the firmware.

Do you mean the values set in wmi.c:: ath10k_wmi_start_scan_init() ?

Should I replace all the scan offload by a mac80211-controlled scan like
in ath9k? The problem then is to switch channels; channel switching
seems very different from ath9k.

Thanks,
JP

> Finally, if that doesn't work, then I could probably fix that in CT
> firmware in case that is of interest.
> 
> Thanks,
> Ben
> 
> >
> > Jean-Pierre Tosoni
> >
> >
> >
> >> -----Message d'origine-----
> >> De : ath10k [mailto:ath10k-bounces@lists.infradead.org] De la part de
> >> Jean-Pierre Tosoni Envoyé : mercredi 30 novembre 2016 19:04 À :
> >> ath10k@lists.infradead.org Objet : Client station sends probes on DFS
> >> channels
> >>
> >> Hello list,
> >>
> >> There is a case where I can see probes on a DFS channel, from a non-
> >> associated station using ath10k. (note that the problem does not
> >> arise when using ath9k).
> >>
> >> *The setup*
> >>
> >> I am using Openwrt, wpa_supplicant and compat-wireless 2016-10-08,
> >> Card firmware is	ath10k_pci: qca988x hw2.0 (0x4100016c, 0x043202ff)
> >> 		fw 10.2.4.70-2 api 5 htt-ver 2.1 wmi-op 5 htt-op 2
> >> 		cal otp max-sta 128 features no-p2p
> >> 	ath10k_pci: debug 0 debugfs 1 tracing 0 dfs 1 testmode 1
> >>
> >> I am using channel 116, regdom US or FR, where I see no traffic at
> >> all using wireshark+Airpcap.
> >> I set wpa_supplicant to scan this channel only for a specific SSID
> >> "ssid1".
> >>
> >> At initial startup of the client device, no probes are going out,
> >> which is OK.
> >>
> >> Then, on another device, I start a hostapd set to channel 116, with a
> >> different SSID "otherssid" so that the supplicant will not associate.
> >>
> >> Shortly (1-2s) after the beacons appear in the air, the client begins
> >> to Send probe request in the air, which is unexpected, but acceptable
> >> since the client can infer absence of radars from the presence of
> beacons.
> >>
> >> *The problem*
> >>
> >> If I power down the AP, the client continues to send probes for
> >> around
> >> 10 minutes, which is unacceptable since it cannot handle radar
> >> detection, as it is a slave device in the meaning of ETSI/EN 301-
> 893[1].
> >>
> >>
> >> Some tests I made:
> >> - I tried to investigate the "beacon hint" mechanism but it appears
> >>   that it is not used on DFS channels.
> >>
> >> - I tried to force the IEEE80211_NO_IR flag when IEEE80211_CHAN_DFS
> >>   is set.
> >>
> >> - When I reload the reg. domain using "iw reg set", the probes cease,
> >>   but will reappear if I cycle my AP again On then Off.
> >>
> >> - When I let the client associate, then disassociate and stop the AP,
> >>   the same problem arises. It disappears if I add a call to
> >>   ath10k_regd_update() in mac.c after a disconnection (This is not a
> >>   fix, since in my case the client never associates).
> >>
> >> - Since at startup, the client does not send probes, I infer that the
> >>   problem is *not* caused by a hidden AP that the card could see but
> >>   not airpcap.
> >>
> >> - I tried with channels 52 and 100, with regdom FR or US: same problem.
> >>
> >> Any ideas?
> >>
> >>
> >> [1] http://www.etsi.org/deliver/etsi_en/301800_301899/301893/
> >> 01.08.01_60/en_301893v010801p.pdf
> > [2] http://lists.shmoo.com/pipermail/hostap/2015-January/031906.html
> >>
> >> J.P. Tosoni - ACKSYS
> >>
> >>
> >>
> >>
> >> _______________________________________________
> >> ath10k mailing list
> >> ath10k@lists.infradead.org
> >> http://lists.infradead.org/mailman/listinfo/ath10k
> >
> 
> 
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
> 
> 
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
