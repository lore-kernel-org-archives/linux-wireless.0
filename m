Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43326 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758782Ab2EKGan (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 02:30:43 -0400
Message-ID: <4FACB14D.4080507@qca.qualcomm.com> (sfid-20120511_083048_636509_0832118F)
Date: Fri, 11 May 2012 09:27:25 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jonathan Bagg <jbagg@lenbrook.com>
CC: Anthony Ginger <mapfly@gmail.com>,
	<linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: ath6kl hostapd
References: <CAK0tYSKLhALwUca2LPiRLfXTK-Qt3Oh3Lvk=V272AXdb=aAP7w@mail.gmail.com> <4F4B25F5.4090204@qca.qualcomm.com> <4F8546C7.40703@qca.qualcomm.com> <4FA036B6.7040002@lenbrook.com> <4FA03939.4080307@qca.qualcomm.com> <4FA0535D.2060907@lenbrook.com> <4FA21468.6060909@qca.qualcomm.com> <4FA43C79.6020202@lenbrook.com> <4FAB7D52.6060803@qca.qualcomm.com> <4FAC0992.6010603@lenbrook.com>
In-Reply-To: <4FAC0992.6010603@lenbrook.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/10/2012 09:31 PM, Jonathan Bagg wrote:
> On 12-05-10 04:33 AM, Kalle Valo wrote:
>> On 05/04/2012 11:30 PM, Jonathan Bagg wrote:
>>> On 12-05-03 01:15 AM, Kalle Valo wrote:
>>>> That might be challenging. I think it's easier if you add debug messages
>>>> and try to pinpoint where it is failing. For example
>>>> ath6kl_cfg80211_change_iface() is a good place to start debugging.
>>> I tried again and it appears that sometimes (<  10 %) I can make
>>> connections to the ath6kl in AP mode.
>> What exactly happens when a connection fails? What client device are you
>> using?
>
> client = ipad and mac book
> 
> Udhcpd keeps sending offers and acks forever.
> Sending OFFER of 192.168.5.80
> Sending OFFER of 192.168.5.80
> Sending ACK to 192.168.5.80
> Sending ACK to 192.168.5.80
> Sending ACK to 192.168.5.80

Maybe it's a broadcast problem or something? Try with manual IPs and
then first run unicast ping separetely both from the client and the AP,
for example:

ping 192.168.5.1

If that works run broadcast ping separetely both from the client and the AP:

ping -b 192.168.1.255

Most likely you need to enable broadcast ping replies to get any answers:

echo 0 > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts

And if MacOS doesn't support broadcast pings install a real operating
system ;)

Kalle
