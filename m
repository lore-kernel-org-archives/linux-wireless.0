Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpauth19.prod.mesa1.secureserver.net ([64.202.165.30]:50999
	"HELO smtpauth19.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753270Ab0IWQUn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 12:20:43 -0400
Message-ID: <B5CFBEFEE0384AECAF4A5D4FDE63EAE5@ChuckPC>
From: "Chuck Crisler" <ccrisler@vgocom.com>
To: "linux-wireless Mail List" <linux-wireless@vger.kernel.org>
Subject: AR9170 woes 
Date: Thu, 23 Sep 2010 12:20:33 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am *STILL* having failures hopping with the AR9170. Here is what happens.

The 9170 sends a NULL function with the power save bit set. I know that the 
APs that we have disregard that and continue sending packets. I have seen 
this in multiple wireshark traces. We then do a scan, select an AP and 
disconnect from the former AP. The disconnect is handled in mac80211/mlme.c. 
The function calls netif_tx_stop_all_queues and netif_carrier_off. I have 
added additional code to flush the local Tx and AR Tx queues, though I do 
check the status before and the queues are always reported to be empty. This 
step seems to fail. We then successfully change the channel. At that point 
in failure cases we resume transmitting data packets to the old AP on the 
new channel. These aren't acked so they are all retransmits. I have a 
wireshark trace that shows this. I stopped the capture 104 seconds (almost 2 
minutes) after the channel change. This seems to prevent the authentication 
messages from being transmitted, as reported by the mac code.

I know that the 9170 Rx handling isn't very good. It seems that the handler 
does *ALL* of it's work with interrupts turned off. What if we called 
netif_tx_stop_all_queues during this time when interrupts are turned off? 
Would that cause the call to silently fail and leave the Tx queues still 
operational? Does the call to netif_tx_stop_all_queues require an interrupt 
to actually stop the queues on the device? If I moved the 
netif_tx_stop_all_queues call to after the channel has been changed (and I 
know that I am not receiving any packets), would this possibly be a 
work-around?

Thank you,
Chuck 

