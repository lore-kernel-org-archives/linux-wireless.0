Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:57262 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020Ab1AaQEV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 11:04:21 -0500
To: =?utf-8?Q?G=C3=A1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: David Gnedt <david.gnedt@davizone.at>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>,
	"Denis 'GNUtoo' Carikli" <GNUtoo@no-log.org>
Subject: Re: [PATCH 18/18] wl1251: disable retry and ACK policy for injected packets
References: <4D45A7BD.705@davizone.at> <4D45B7DF.1030703@davizone.at>
	<AANLkTik5nkCT6Xbg0SF4oggCXiQjn4EybDq_RKmjPko+@mail.gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Mon, 31 Jan 2011 18:04:20 +0200
In-Reply-To: <AANLkTik5nkCT6Xbg0SF4oggCXiQjn4EybDq_RKmjPko+@mail.gmail.com>
 (=?utf-8?Q?=22G=C3=A1bor?= Stefanik"'s message of "Mon\, 31 Jan 2011
 00\:08\:35 +0100")
Message-ID: <871v3tdpq3.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gábor Stefanik <netrolller.3d@gmail.com> writes:

> On Sun, Jan 30, 2011 at 8:11 PM, David Gnedt <david.gnedt@davizone.at> wrote:
>> Set the retry limit to 0 and disable the ACK policy for injected
>> packets.
>
> Unfortunately this is not the right thing to do - something like this
> should be done in mac80211, but triggered by radiotap (sometimes, it
> makes sense to inject packets and expect ACKs). See the list for
> earlier discussions about the TX Flags field, and
> patches.aircrack-ng.org for a proof-of-concept implementation.

Agreed. Again I prefer the less-logic-in-the-driver philosophy.

-- 
Kalle Valo
