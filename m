Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60769 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab1A2AVL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 19:21:11 -0500
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id p0T0LATR013871
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Fri, 28 Jan 2011 16:21:10 -0800
Message-ID: <4D435D76.2040703@candelatech.com>
Date: Fri, 28 Jan 2011 16:21:10 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: hti->control_chan is 15??
References: <4D4345A8.6060806@candelatech.com>
In-Reply-To: <4D4345A8.6060806@candelatech.com>
Content-Type: multipart/mixed;
 boundary="------------000809060708050303080209"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000809060708050303080209
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 01/28/2011 02:39 PM, Ben Greear wrote:
> When testing with 60 stations, 30 against a netgear running HT40
> and 30 against a cheap cisco AP, using HT20, I notice that the
> stations on the netgear often choose NO_HT instead of HT40
> for their channel type.
>
> The root cause appears to be that the hti->control_chan is 15
> in the ieee80211_enable_ht method.
>
> Everything *should* be running on channel 11.
>
> Is this just a bug with the AP, or could this be a local
> issue?

I sniffed on a separate machine (using ath9k NIC), and it agrees
that the beacon's control_channel is 14 (I have since set the AP to channel
10 instead of 11, but the control_channel remains 4 higher than expected.)

I'm attaching the pkt in pcap format as well.

(From wireshark):

        Vendor Specific: 00:90:4c: HT Additional Capabilities (802.11n D1.00)
             Tag Number: 221 (Vendor Specific)
             Tag length: 26
             Vendor: 00:90:4c
             Tag interpretation: 802.11n (Pre) OUI
             Tag interpretation: HT additional information (802.11n D1.00)
             Tag interpretation: Control Channel 14
             HT Additional Capabilities: 0x000F
                 .... .... .... ..11 = Extension Channel Offset: Extension Channel below control channel (0x0003)
                 .... .... .... .1.. = Recommended Tx Channel Width: Any channel width enabled
                 .... .... .... 1... = Reduced Interframe Spacing (RIFS) Mode: Use of RIFS permitted
                 .... .... ...0 .... = Controlled Access Only: PSMP only
                 .... .... 000. .... = Service Interval Granularity: 5ms (0x0000)
             HT Additional Capabilities: 0x0008
                 .... .... .... ..00 = Operating Mode: Pure HT, no protection (0x0000)
                 .... .... .... .0.. = Non Greenfield (GF) devices Present: One or More HT devices are not GF capable
             HT Additional Capabilities: 0x0000
                 .... .... .000 0000 = Basic STB Modulation and Coding Scheme (MCS): 0x0000
                 .... .... 0... .... = Dual Clear To Send (CTS) Protection: Regular use of RTS/CTS
                 .... ...0 .... .... = Secondary Beacon: Primary Beacon
                 .... ..0. .... .... = L-SIG TXOP Protection Support: Not full support
                 .... .0.. .... .... = Phased Coexistence Operation (PCO) Active: PCO is not activated in the BSS
                 .... 0... .... .... = Phased Coexistence Operation (PCO) Phase: Switch to 40MHz phase/keep 40MHz
             Rx Supported Modulation and Coding Scheme Set (VS): MCS Set
                 Tag interpretation: Rx Modulation and Coding Scheme (One bit per modulation)
                     .... .... .... .... .... .... 0000 0000 = Rx Bitmask Bits 0-7: 0x00000000
                     .... .... .... .... 0000 0000 .... .... = Rx Bitmask Bits 8-15: 0x00000000
                     .... .... 0000 0000 .... .... .... .... = Rx Bitmask Bits 16-23: 0x00000000
                     0000 0000 .... .... .... .... .... .... = Rx Bitmask Bits 24-31: 0x00000000
                     .... .... .... .... .... .... .... ...0 = Rx Bitmask Bit 32: 0x00000000
                     .... .... .... .... .... .... .000 000. = Rx Bitmask Bits 33-38: 0x00000000
                     .... .... ...0 0000 0000 0000 0... .... = Rx Bitmask Bits 39-52: 0x00000000
                     ...0 0000 0000 0000 0000 0000 000. .... = Rx Bitmask Bits 53-76: 0x00000000
                 Highest Supported Data Rate: 0x0000
                 .... .... .... ...0 = Tx Supported MCS Set: Not Defined
                 .... .... .... ..0. = Tx and Rx MCS Set: Equal
                 .... .... .... 00.. = Tx Maximum Number of Spatial Streams Supported: 1 spatial stream (0x0000)
                 .... .... ...0 .... = Unequal Modulation: Not supported
         HT Information (802.11n D1.10)
             Tag Number: 61 (HT Information (802.11n D1.10))
             Tag length: 22
             Primary Channel: 14
             HT Information Subset (1 of 3): 0x0F
                 .... ..11 = Secondary channel offset: Secondary channel is below the primary channel (0x03)
                 .... .1.. = Supported channel width: Channel of any width supported
                 .... 1... = Reduced Interframe Spacing (RIFS): Permitted
                 ...0 .... = Power Save Multi-Poll (PSMP) stations only: Association requests are accepted regardless of PSMP capability
                 000. .... = Shortest service interval: 5 ms (0x00)
             HT Information Subset (2 of 3): 0x0008
                 .... .... .... ..00 = Operating mode of BSS: All STAs are - 20/40 MHz HT or in a 20/40 MHz BSS or are 20 MHz HT in a 20 MHz BSS (0x0000)
                 .... .... .... .0.. = Non-greenfield STAs present: All associated STAs are greenfield capable
                 .... .... .... 1... = Transmit burst limit: 2.4 GHz - 6.16 ms | All other bands - 3.08 ms
                 .... .... ...0 .... = OBSS non-HT STAs present: Use of protection for non-HT STAs by overlapping BSSs is not needed
                 0000 0000 000. .... = Reserved: 0x0000
             HT Information Subset (3 of 3): 0x0000
                 .... .... ..00 0000 = Reserved: 0x0000
                 .... .... .0.. .... = Dual beacon: No second beacon is transmitted
                 .... .... 0... .... = Dual Clear To Send (CTS) protection: Not required
                 .... ...0 .... .... = Beacon ID: Primary beacon
                 .... ..0. .... .... = L-SIG TXOP Protection Full Support: One or more HT STAs in the BSS do not support L-SIG TXOP protection
                 .... .0.. .... .... = Phased Coexistence Operation (PCO): Inactive
                 .... 0... .... .... = Phased Coexistence Operation (PCO) Phase: Switch to or continue 20 MHz phase
                 0000 .... .... .... = Reserved: 0x0000
             Rx Supported Modulation and Coding Scheme Set: Basic MCS Set
                 Tag interpretation: Rx Modulation and Coding Scheme (One bit per modulation)
                     .... .... .... .... .... .... 0000 0000 = Rx Bitmask Bits 0-7: 0x00000000
                     .... .... .... .... 0000 0000 .... .... = Rx Bitmask Bits 8-15: 0x00000000
                     .... .... 0000 0000 .... .... .... .... = Rx Bitmask Bits 16-23: 0x00000000
                     0000 0000 .... .... .... .... .... .... = Rx Bitmask Bits 24-31: 0x00000000
                     .... .... .... .... .... .... .... ...0 = Rx Bitmask Bit 32: 0x00000000
                     .... .... .... .... .... .... .000 000. = Rx Bitmask Bits 33-38: 0x00000000
                     .... .... ...0 0000 0000 0000 0... .... = Rx Bitmask Bits 39-52: 0x00000000
                     ...0 0000 0000 0000 0000 0000 000. .... = Rx Bitmask Bits 53-76: 0x00000000
                 Highest Supported Data Rate: 0x0000
                 .... .... .... ...0 = Tx Supported MCS Set: Not Defined
                 .... .... .... ..0. = Tx and Rx MCS Set: Equal
                 .... .... .... 00.. = Tx Maximum Number of Spatial Streams Supported: 1 spatial stream (0x0000)
                 .... .... ...0 .... = Unequal Modulation: Not supported

>
> Thanks,
> Ben
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


--------------000809060708050303080209
Content-Type: application/octet-stream;
 name="wifi-n-bad-ctrl-channel.pcap"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="wifi-n-bad-ctrl-channel.pcap"

1MOyoQIABAAAAAAAAAAAAP//AAB/AAAAK1lDTQ/CBQA3AQAANwEAAAAAGgAvSAAAD73NIgAA
AAAQApQJoADjAQAAgAAAAP///////zBGmhALmjBGmhALmmB3gP3ZegAAAABkACEEAA1uZXRn
ZWFyLTJnLTAxAQiChIuWDBIYJAMBCgUEAQIAACoBADIEMEhgbN0YAFDyAgEBgwADpAAAJ6QA
AEJDXgBiMi8A3R4AkEwzzhEb//8AAAAAAAAAAAAAAAAAAAAAAAAAAAAtGs4RG///AAAAAAAA
AAAAAAAAAAAAAAAAAAAA3RoAkEw0Dg8IAAAAAAAAAAAAAAAAAAAAAAAAAD0WDg8IAAAAAAAA
AAAAAAAAAAAAAAAAAN0JAAN/AQEAAP9/3QoAA38EAQACAEAA3ScAUPIEEEoAARAQRAABAhBH
ABAAAAAAAAAQAAAAMEaaEAuaEDwAAQMwhF2t
--------------000809060708050303080209--
