Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp06.msg.oleane.net ([62.161.4.6]:55032 "EHLO
	smtp06.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121AbbDMQHN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2015 12:07:13 -0400
Received: from RD9 ([195.6.104.67]) (authenticated)
	by smtp06.msg.oleane.net (MSA) with ESMTP id t3DG0jAw000415
	for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2015 18:00:45 +0200
From: "Jean-Pierre Tosoni" <jp.tosoni@acksys.fr>
To: "'mailto:linux-wireless@vger.kernel.org'"@smtp06.msg.oleane.net
Subject: [mac80211] 4-addresses mode: the AP does not detect the advertizing null data frame from the client
Date: Mon, 13 Apr 2015 18:07:10 +0200
Message-ID: <000701d07603$e5f5b910$b1e12b30$@acksys.fr> (sfid-20150413_180721_835932_EF17D546)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0008_01D07614.A97E8910"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multipart message in MIME format.

------=_NextPart_000_0008_01D07614.A97E8910
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello list,

 

I am using compat-wireless-2014-11-04 and hostapd-2014-06-03 in an openwrt
environment.

I have set up a wpa_supplicant and an AP using Atheros chips. The supplicant
is set in 4-addresses mode. The AP is set to put its 4-addresses clients
into a bridge.

 

Symptom: the supplicant associates to the AP as expected. But from the AP it
is not possible to ping the PC connected behind the supplicant, until that
PC send something (an ARP or whatever data frame).

The reason I found is that hostapd does not put the 4-addr station in the
bridge.

 

I noticed that in mac80211/mlme.c the client station sends a null data frame
to inform the AP that it will use the 4-addresses format. On the AP, hostapd
logs show that it does not receive an event for this frame,  but it receives
a 4-addr event alright on a subsequent, real data frame.

I also noticed that in mac80211/rx.c the ieee80211_rx_h_sta_process()
function sends an event to userspace. But in the case of the first
null-data, the frame is trapped before, in ieee80211_rx_h_check(), in the
test of cfg80211_rx_spurious_frame().

 

So, though everything looks all set for the AP to detect its 4-addr client,
this does not occur if the client does not send real data.

I tried to move the event generation code from ieee80211_rx_h_sta_process()
to ieee80211_rx_h_check(), but this does not work, it looks like rx->sta
does not exist yet at this point in the frame processing.

I'm stuck now.

 

Any ideas?

 

 


------=_NextPart_000_0008_01D07614.A97E8910
Content-Type: application/ms-tnef;
	name="winmail.dat"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="winmail.dat"

eJ8+IgoQAQaQCAAEAAAAAAABAAEAAQeQBgAIAAAA5AQAAAAAAADoAAEIgAcAGAAAAElQTS5NaWNy
b3NvZnQgTWFpbC5Ob3RlADEIAQYABwABAAAAAAAAAQOQBgDsDwAAKAAAAAsAAgABAAAAAwAmAAAA
AAALACkAAAAAAAIBMQABAAAARgAAAAAAAAB3z2mrZNd9RKy22QcnT8lvBwB3PbioKragRq4BlcaG
EqMZAAAABOSzAABEj16n5EP/SZYmQsQCqf7CAAAPDWCeAAAAAB4AcAABAAAAZAAAAFttYWM4MDIx
MV0gNC1hZGRyZXNzZXMgbW9kZTogdGhlIEFQIGRvZXMgbm90IGRldGVjdCB0aGUgYWR2ZXJ0aXpp
bmcgbnVsbCBkYXRhIGZyYW1lIGZyb20gdGhlIGNsaWVudAACAXEAAQAAABYAAAAB0HYBjQ+eJ30T
ImZHbblP6Yh4FNdAAAALAAEOAAAAAAIBCg4BAAAALgAAAAAAAAB3z2mrZNd9RKy22QcnT8lvAQB3
PbioKragRq4BlcaGEqMZAAAABOS1AAAAAAMAFA4BAAAAHgAoDgEAAAAxAAAAMDAwMDAwMDQBanAu
dG9zb25pQGFja3N5cy5mcgFqcC50b3NvbmlAYWNrc3lzLmZyAAAAAB4AKQ4BAAAAMQAAADAwMDAw
MDA0AWpwLnRvc29uaUBhY2tzeXMuZnIBanAudG9zb25pQGFja3N5cy5mcgAAAAACARQ6AQAAABAA
AACsqWPAodStRoIxUsE/wEYEAwDeP59OAAADAPE/DAQAAB4A+j8BAAAAFAAAAGpwLnRvc29uaUBh
Y2tzeXMuZnIAAwACWQAAFgADAAlZAgAAAAMAFIAIIAYAAAAAAMAAAAAAAABGAAAAABCFAAAAAAAA
CwAggAggBgAAAAAAwAAAAAAAAEYAAAAAA4UAAAAAAAADACeACCAGAAAAAADAAAAAAAAARgAAAAAB
hQAAAAAAAAsAKIAIIAYAAAAAAMAAAAAAAABGAAAAAA6FAAAAAAAAAwAsgAggBgAAAAAAwAAAAAAA
AEYAAAAAGIUAAAAAAAALAC2ACCAGAAAAAADAAAAAAAAARgAAAACChQAAAQAAAAsALoAIIAYAAAAA
AMAAAAAAAABGAAAAAAaFAAAAAAAACwAfDgEAAAACAfgPAQAAABAAAAAJoiyeOHGWQoxlqfLC6v/r
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
BB8TXwbf//Lf8+8XTwg/CU8KXwtvDH//DY8bvw+vEL8RzxLfE+8U//8WDxcfGC8ZPxpPG18cby2P
/x6PH58gryG/Is8j3yxqK2A5LUEvZFDQM483r2c1qjgxoWK9YHkHrjcxoQsvQiSwfT8QAwANNP0/
rQ4DAA80/T+tDgIBFDQBAAAAEAAAAFSUocApfxAbpYcIACsqJRcCAeJlAQAAABQAAACLttRNfqlb
SIgzb1snV1xJAAIIPgIB42UBAAAAFQAAABSLttRNfqlbSIgzb1snV1xJAAIIPgAAAAIBfwABAAAA
jQAAADAwMDAwMDAwNzdDRjY5QUI2NEQ3N0Q0NEFDQjZEOTA3Mjc0RkM5NkYwNzAwNzczREI4QTgy
QUI2QTA0NkFFMDE5NUM2ODYxMkEzMTkwMDAwMDAwNEU0QjQwMDAwNDQ4RjVFQTdFNDQzRkY0OTk2
MjY0MkM0MDJBOUZFQzIwMDAwMEYwRDU0REEwMDAwAAAAAAMABhAjK7aiAwAHEJUEAAADABAQAAAA
AAMAERAAAAAAHgAIEAEAAABlAAAASEVMTE9MSVNULElBTVVTSU5HQ09NUEFULVdJUkVMRVNTLTIw
MTQtMTEtMDRBTkRIT1NUQVBELTIwMTQtMDYtMDNJTkFOT1BFTldSVEVOVklST05NRU5USUhBVkVT
RVRVUEFXUAAAAAB5mg==

------=_NextPart_000_0008_01D07614.A97E8910--

