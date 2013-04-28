Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48839 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754310Ab3D1BWH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Apr 2013 21:22:07 -0400
Message-ID: <517C79B7.1090306@openwrt.org> (sfid-20130428_032211_472379_58C57E3B)
Date: Sun, 28 Apr 2013 03:21:59 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: Oleksij Rempel <linux@rempel-privat.de>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] [PATCH v2] ath9k: collect statistics about Rx-Dup
 and Rx-STBC packets
References: <1367076326-21616-1-git-send-email-linux@rempel-privat.de> <1367087995-8960-1-git-send-email-linux@rempel-privat.de> <CAJ-VmonF9XaVZ6MkP-T3cdfGNjXaroM-rXYcA=TUndicp77UnQ@mail.gmail.com> <517C1EC1.8060808@rempel-privat.de> <CAJ-VmokUFtFjQk0T87E57kEhp40f1v4XgJL-iN35Bzo4h-McDQ@mail.gmail.com>
In-Reply-To: <CAJ-VmokUFtFjQk0T87E57kEhp40f1v4XgJL-iN35Bzo4h-McDQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-04-27 9:06 PM, Adrian Chadd wrote:
> On 27 April 2013 11:53, Oleksij Rempel <linux@rempel-privat.de> wrote:
> 
>>> (And then go and re-align things inside that struct so you don't waste
>>> space.)
>>
>>
>> hmm.. what do you mean here?
> 
> Structure alignment? Well, you typically want to have everything be
> dword aligned (32 bits) or word (16 bits) aligned. Otherwise the
> compiler may insert extra padding between fields in order to meet
> alignment requirements on platforms that need it (MIPS, older ARM) or
> platforms that perform slower (newer ARM.)
I think in struct ath_rx_status alignment does not matter much, it's
only kept on the stack anyway. But yes, in other cases it makes sense to
pay attention to padding to keep structs small. I also agree that making
rs_flags u16 is a good idea.

> Now, i don't know what 'bool' is, whether it's a byte, word or dword.
bool is a byte.

> That "is_mybeacon" field should probably be just another flag in
> rx_status, then just extend 'rs_flags' to 16 bits and include it. That
> way the alignment is easy to see - all the fields in rx_status and the
> htc rx_status structs have explicit sizes. :-)
> 
> Felix, what do you think?
Sounds good :)

- Felix

