Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:62106 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512Ab3D0TOA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Apr 2013 15:14:00 -0400
Received: from mailout-de.gmx.net ([10.1.76.17]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0M9M3c-1UKb2f0Fzi-00Cjjo for
 <linux-wireless@vger.kernel.org>; Sat, 27 Apr 2013 21:13:59 +0200
Message-ID: <517C2375.3030907@rempel-privat.de> (sfid-20130427_211405_161950_F94CFB34)
Date: Sat, 27 Apr 2013 21:13:57 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: Felix Fietkau <nbd@nbd.name>, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath9k: collect statistics about Rx-Dup and Rx-STBC
 packets
References: <1367076326-21616-1-git-send-email-linux@rempel-privat.de> <1367087995-8960-1-git-send-email-linux@rempel-privat.de> <CAJ-VmonF9XaVZ6MkP-T3cdfGNjXaroM-rXYcA=TUndicp77UnQ@mail.gmail.com> <517C1EC1.8060808@rempel-privat.de> <CAJ-VmokUFtFjQk0T87E57kEhp40f1v4XgJL-iN35Bzo4h-McDQ@mail.gmail.com>
In-Reply-To: <CAJ-VmokUFtFjQk0T87E57kEhp40f1v4XgJL-iN35Bzo4h-McDQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 27.04.2013 21:06, schrieb Adrian Chadd:
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
>
> Eg:
>
> u32 a;
> u16 b;
> u8 c;
> u8 d;
>
> .. that's fine - the u32 is dword aligned, the u16 is word aligned,
> the u8's don't need aligning.
>
> But, considder:
>
> u32 a;
> u8 b;
> u16 c;
> u8 d;
>
> .. u32 is dword aligned, u8 b is fine as it's a a byte and doesn't
> need aligning, but 'u16 c' isn't dword aligned! So the compiler will
> insert a byte padding between 'b' and 'c'.
>
> same deal with:
>
> u32 a;
> u16 b;
> u32 c;
>
> .. 'a' is fine; 'b' is fine, but 'c' starts at a word boundary, not a
> dword boundary.
>
> Hence why things like IP/TCP headers and such look the way they do. :-)
>
> Now, i don't know what 'bool' is, whether it's a byte, word or dword.
> That "is_mybeacon" field should probably be just another flag in
> rx_status, then just extend 'rs_flags' to 16 bits and include it. That
> way the alignment is easy to see - all the fields in rx_status and the
> htc rx_status structs have explicit sizes. :-)

ok, i was not sure if you mean what i think :)
I would prefer to do this in separate patch.

-- 
Regards,
Oleksij
