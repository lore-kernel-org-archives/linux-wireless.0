Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns2.inescn.pt ([192.35.246.20]:32975 "EHLO trubo.inescn.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbbBSO7a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2015 09:59:30 -0500
Received: from localhost (localhost [127.0.0.1])
	by trubo.inescn.pt (8.13.8/8.14.3/7) with ESMTP id t1JErrGB009963
	for <linux-wireless@vger.kernel.org>; Thu, 19 Feb 2015 14:53:53 GMT
Received: from trubo.inescn.pt ([127.0.0.1])
	by localhost (trubo.inescn.pt [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id gBmmZxuzgnH6 for <linux-wireless@vger.kernel.org>;
	Thu, 19 Feb 2015 14:53:48 +0000 (WET)
Received: from grover.inescn.pt (grover.inescn.pt [194.117.24.20])
	by trubo.inescn.pt (8.13.8/8.14.4/3) with ESMTP id t1JErjfq009956
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Thu, 19 Feb 2015 14:53:45 GMT
Received: from grover.inescn.pt (localhost.localdomain [127.0.0.1])
	by grover.inescn.pt (8.13.8/8.13.8/7) with ESMTP id t1JErjf3022071
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 19 Feb 2015 14:53:45 GMT
Received: (from apache@localhost)
	by grover.inescn.pt (8.13.8/8.13.8/Submit) id t1JErjBH022069
	for linux-wireless@vger.kernel.org; Thu, 19 Feb 2015 14:53:45 GMT
Message-ID: <20150219155345.54713ultwqjbtrsp@horde.inescporto.pt> (sfid-20150219_155933_931495_00F2831B)
Date: Thu, 19 Feb 2015 15:53:45 +0100
From: =?iso-8859-1?b?TeFyaW8=?= Lopes <mjlopes@inescporto.pt>
To: linux-wireless@vger.kernel.org
Subject: Issue with frame injection on monitor interface (ath9k)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi everyone.

When using frame injection over monitor interface, with handmade  
packet with Radiotap header + QoS + Data, at sender I capture the  
packet with tcpdump and it is equal to the one I sent.
Although, at receiver station, the packet is diferent, FCS was  
recalculated or forced to active and calculated, MCS is not the one I  
supplied, sequence number (QoS field) is not the same, amongst other  
things.
Also, QoS Ack policy was "No Ack" at sender (QoS Control = 0x0020), a  
Ack frame was transmitted to sender and the received packet arrived  
with QoS Control = 0x0000.

Tested with Microtik R52n-M (AR9220) on following operating systems:
- AP-STA using Ubuntu Ubuntu 14.04.1 LTS;
- AdHoc using OpenWRT r43000, with kmod-ath9k version  
3.10.49+2014-11-04-1 and kmod-mac80211 version 3.10.49+2014-11-04-1.

Regarding to OpenWRT, this malfunction was reported here:  
https://dev.openwrt.org/ticket/18913

Thanks.




----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.
