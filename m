Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.platinumzone24.at ([88.198.159.93]:46526 "EHLO
	mail.platinumzone24.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab1AaXDN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 18:03:13 -0500
Message-ID: <4D473F9B.5040803@davizone.at>
Date: Tue, 01 Feb 2011 00:02:51 +0100
From: David Gnedt <david.gnedt@davizone.at>
MIME-Version: 1.0
To: Kalle Valo <kvalo@adurom.com>
CC: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: Re: [PATCH 18/18] wl1251: disable retry and ACK policy for injected
 packets
References: <4D45A7BD.705@davizone.at> <4D45B7DF.1030703@davizone.at>	<AANLkTik5nkCT6Xbg0SF4oggCXiQjn4EybDq_RKmjPko+@mail.gmail.com> <871v3tdpq3.fsf@purkki.adurom.net>
In-Reply-To: <871v3tdpq3.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 2011-01-31 17:04, schrieb Kalle Valo:
> Gábor Stefanik <netrolller.3d@gmail.com> writes:
> 
>> On Sun, Jan 30, 2011 at 8:11 PM, David Gnedt <david.gnedt@davizone.at> wrote:
>>> Set the retry limit to 0 and disable the ACK policy for injected
>>> packets.
>>
>> Unfortunately this is not the right thing to do - something like this
>> should be done in mac80211, but triggered by radiotap (sometimes, it
>> makes sense to inject packets and expect ACKs). See the list for
>> earlier discussions about the TX Flags field, and
>> patches.aircrack-ng.org for a proof-of-concept implementation.
> 
> Agreed. Again I prefer the less-logic-in-the-driver philosophy.

Yeah, you are right. I will remove the IEEE80211_TX_CTL_INJECTED check, but I
think the rate class setting for IEEE80211_TX_CTL_NO_ACK frames is still needed,
as my testing showed that the ack_policy setting is not sufficient to disable
retries.
