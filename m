Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44173 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758515Ab2DYA0L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 20:26:11 -0400
Message-ID: <4F97449F.5040505@candelatech.com> (sfid-20120425_022617_234397_A91B1915)
Date: Tue, 24 Apr 2012 17:26:07 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Subject: Re: Strange problem with ath9k and ASUS N66U AP.
References: <4F972E3F.4020609@candelatech.com>
In-Reply-To: <4F972E3F.4020609@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/24/2012 03:50 PM, Ben Greear wrote:
> I am trying some ath9k virtual clients against an ASUS N66U.
>
> Kernel is 3.3.3+, but we've been seeing weird things since at
> least 3.0 kernel with another Asus AP, but haven't looked at
> the problem in detail on older kernels yet.
>
> The issue seems to be that the ath9k side thinks all is well,
> but the N66U shows it as not authenticated.
>
> If anyone has any ideas on how to go about debugging
> this, please let me know.
>
> sta11 is :0C, and is not working properly
> sta12 is :0D, and is working fine.
>
> Here is part of the N66U wifi log showing that it
> thinks sta11 is not authorized:
>
> 00:95:95:00:00:0C  associated
> 00:95:95:00:00:0D  associated authorized

Here's a better log.  Makes me think supplicant might be at fault???

sta8 failed, sta9 works fine.  The difference appears to be the extra
RX EAPOL packet that sta8 receives...

1335313181.632116: sta8: Event ASSOC (0) received
1335313181.632121: sta8: Association info event
1335313181.632151: sta8: freq=2462 MHz
1335313181.632155: sta8: State: ASSOCIATING -> ASSOCIATED
1335313181.632171: sta8: Associated to a new BSS: BSSID=c8:60:00:e8:88:b0
1335313181.632194: sta8: No keys have been configured - skip key clearing
1335313181.632199: sta8: Associated with c8:60:00:e8:88:b0
1335313181.632203: sta8: WPA: Association event - clear replay counter
1335313181.632207: sta8: WPA: Clear old PTK
1335313181.632313: sta8: Setting authentication timeout: 10 sec 0 usec
1335313181.632318: sta8: Cancelling scan request
1335313181.965215: sta8: RX EAPOL from c8:60:00:e8:88:b0
1335313181.965261: sta8: Setting authentication timeout: 10 sec 0 usec
1335313181.965276: sta8: IEEE 802.1X RX: version=2 type=3 length=117
1335313181.965286: sta8:   EAPOL-Key type=2
1335313181.965294: sta8:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
1335313181.965302: sta8:   key_length=16 key_data_length=22
1335313181.965358: sta8: State: ASSOCIATED -> 4WAY_HANDSHAKE
1335313181.965364: sta8: WPA: RX message 1 of 4-Way Handshake from c8:60:00:e8:88:b0 (ver=2)
1335313181.965386: sta8: RSN: no matching PMKID found
1335313181.965838: sta8: WPA: Sending EAPOL-Key 2/4
1335313181.999176: sta8: RX EAPOL from c8:60:00:e8:88:b0
1335313181.999235: sta8: IEEE 802.1X RX: version=2 type=3 length=175
1335313181.999241: sta8:   EAPOL-Key type=2
1335313181.999248: sta8:   key_info 0x13ca (ver=2 keyidx=0 rsvd=0 Pairwise Install Ack MIC Secure Encr)
1335313181.999253: sta8:   key_length=16 key_data_length=80
1335313181.999414: sta8: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
1335313181.999422: sta8: WPA: RX message 3 of 4-Way Handshake from c8:60:00:e8:88:b0 (ver=2)
1335313181.999465: sta8: WPA: Sending EAPOL-Key 4/4
1335313181.999526: sta8: WPA: Installing PTK to the driver
1335313181.999655: sta8: State: 4WAY_HANDSHAKE -> GROUP_HANDSHAKE
1335313181.999671: sta8: WPA: Installing GTK to the driver (keyidx=1 tx=0 len=32)
1335313181.999745: sta8: WPA: Key negotiation completed with c8:60:00:e8:88:b0 [PTK=CCMP GTK=TKIP secure=512 dbg=pairwise-gtk]
1335313181.999753: sta8: Cancelling authentication timeout
1335313181.999759: sta8: State: GROUP_HANDSHAKE -> COMPLETED
1335313181.999764: sta8: CTRL-EVENT-CONNECTED - Connection to c8:60:00:e8:88:b0 completed (auth) [id=0 id_str=]
1335313182.000884: RTM_NEWLINK, IFLA_IFNAME: Interface 'sta8' added

1335313182.063407: sta8: RX EAPOL from c8:60:00:e8:88:b0
1335313182.063475: sta8: IEEE 802.1X RX: version=2 type=3 length=175
1335313182.063482: sta8:   EAPOL-Key type=2
1335313182.063491: sta8:   key_info 0x13ca (ver=2 keyidx=0 rsvd=0 Pairwise Install Ack MIC Secure Encr)
1335313182.063497: sta8:   key_length=16 key_data_length=80
1335313182.063685: sta8: State: COMPLETED -> 4WAY_HANDSHAKE
1335313182.063695: sta8: WPA: RX message 3 of 4-Way Handshake from c8:60:00:e8:88:b0 (ver=2)
1335313182.063745: sta8: WPA: Sending EAPOL-Key 4/4
1335313182.063842: sta8: WPA: Installing PTK to the driver
1335313182.069303: sta8: State: 4WAY_HANDSHAKE -> GROUP_HANDSHAKE
1335313182.069318: sta8: WPA: Installing GTK to the driver (keyidx=1 tx=0 len=32)
1335313182.082245: sta8: WPA: Key negotiation completed with c8:60:00:e8:88:b0 [PTK=CCMP GTK=TKIP secure=512 dbg=pairwise-gtk]
1335313182.082261: sta8: Cancelling authentication timeout
1335313182.082270: sta8: State: GROUP_HANDSHAKE -> COMPLETED


1335313181.588919: RTM_NEWLINK, IFLA_IFNAME: Interface 'sta9' added
1335313181.588949: RTM_NEWLINK, IFLA_IFNAME: Interface 'sta9' added
1335313181.631797: sta9: Event ASSOC (0) received
1335313181.631802: sta9: Association info event
1335313181.631825: sta9: freq=2462 MHz
1335313181.631829: sta9: State: ASSOCIATING -> ASSOCIATED
1335313181.631845: sta9: Associated to a new BSS: BSSID=c8:60:00:e8:88:b0
1335313181.631868: sta9: No keys have been configured - skip key clearing
1335313181.631873: sta9: Associated with c8:60:00:e8:88:b0
1335313181.631877: sta9: WPA: Association event - clear replay counter
1335313181.631881: sta9: WPA: Clear old PTK
1335313181.631984: sta9: Setting authentication timeout: 10 sec 0 usec
1335313181.631990: sta9: Cancelling scan request
1335313181.963212: sta9: RX EAPOL from c8:60:00:e8:88:b0
1335313181.963250: sta9: Setting authentication timeout: 10 sec 0 usec
1335313181.963262: sta9: IEEE 802.1X RX: version=2 type=3 length=117
1335313181.963279: sta9:   EAPOL-Key type=2
1335313181.963289: sta9:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
1335313181.963298: sta9:   key_length=16 key_data_length=22
1335313181.963409: sta9: State: ASSOCIATED -> 4WAY_HANDSHAKE
1335313181.963420: sta9: WPA: RX message 1 of 4-Way Handshake from c8:60:00:e8:88:b0 (ver=2)
1335313181.963457: sta9: RSN: no matching PMKID found
1335313181.964203: sta9: WPA: Sending EAPOL-Key 2/4
1335313181.997092: sta9: RX EAPOL from c8:60:00:e8:88:b0
1335313181.997141: sta9: IEEE 802.1X RX: version=2 type=3 length=175
1335313181.997148: sta9:   EAPOL-Key type=2
1335313181.997156: sta9:   key_info 0x13ca (ver=2 keyidx=0 rsvd=0 Pairwise Install Ack MIC Secure Encr)
1335313181.997162: sta9:   key_length=16 key_data_length=80
1335313181.997343: sta9: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
1335313181.997351: sta9: WPA: RX message 3 of 4-Way Handshake from c8:60:00:e8:88:b0 (ver=2)
1335313181.997402: sta9: WPA: Sending EAPOL-Key 4/4
1335313181.997468: sta9: WPA: Installing PTK to the driver
1335313181.997584: sta9: State: 4WAY_HANDSHAKE -> GROUP_HANDSHAKE
1335313181.997599: sta9: WPA: Installing GTK to the driver (keyidx=1 tx=0 len=32)
1335313181.997688: sta9: WPA: Key negotiation completed with c8:60:00:e8:88:b0 [PTK=CCMP GTK=TKIP secure=512 dbg=pairwise-gtk]
1335313181.997697: sta9: Cancelling authentication timeout
1335313181.997705: sta9: State: GROUP_HANDSHAKE -> COMPLETED
1335313181.997713: sta9: CTRL-EVENT-CONNECTED - Connection to c8:60:00:e8:88:b0 completed (auth) [id=0 id_str=]
1335313181.998971: RTM_NEWLINK, IFLA_IFNAME: Interface 'sta9' added



-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

