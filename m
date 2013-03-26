Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:34341 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab3CZTU4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Mar 2013 15:20:56 -0400
Received: by mail-la0-f46.google.com with SMTP id fq12so14308170lab.33
        for <linux-wireless@vger.kernel.org>; Tue, 26 Mar 2013 12:20:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130326154026.GA15695@jouni.qca.qualcomm.com>
References: <20130325101251.GA8819@jouni.qca.qualcomm.com> <CA+55aFyxn6U0bx-JWF3GDatvObgSKWB6skCBp07M=MtwQb2_Mg@mail.gmail.com>
 <CA+55aFxy2rFGykxo2sKDVDp2Z56ZbRi1pX_L99ENZ8W=Es6apQ@mail.gmail.com>
 <20130325113001.GA26285@jouni.qca.qualcomm.com> <CA+55aFzAAFUDKi37f+9KZ1T7QUpRE7Y=PJt7nNGCnC6NU4XUVQ@mail.gmail.com>
 <20130325163514.GA9373@jouni.qca.qualcomm.com> <CA+55aFyCDpx4D8FSKkG_aMee9_71ycKLZxEGDOzhwuJ1DVQeZA@mail.gmail.com>
 <CA+55aFz1mQbmBu9=cAp=rNvTtESvJokGWNtbxiZ82D7KNqRtDg@mail.gmail.com>
 <20130326095829.GA5612@jouni.qca.qualcomm.com> <CA+55aFw7OO1KtW38Ph0Ru__Q8K-tDVN3tL=8g-hn_1fGUnxoqg@mail.gmail.com>
 <20130326154026.GA15695@jouni.qca.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Tue, 26 Mar 2013 12:20:33 -0700
Message-ID: <CAB=NE6XrAKuqvB74cScdGypprs-Tzex7ZsrRpRWo0-arbueaSQ@mail.gmail.com> (sfid-20130326_202102_374453_02F36278)
Subject: Re: [ath9k-devel] ath9k not connecting to one particular network..
To: Jouni Malinen <jouni@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Dan Williams <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	=?UTF-8?Q?Joel_Wir=C4=81mu_Pauling?= <joel@aenertia.net>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding linux-wireless, not sure if many people read this list.

  Luis

On Tue, Mar 26, 2013 at 8:40 AM, Jouni Malinen <jouni@qca.qualcomm.com> wrote:
> On Tue, Mar 26, 2013 at 08:25:20AM -0700, Linus Torvalds wrote:
>> Ok, added to the bugzilla. I'm still in the condo, but I'm leaving
>> soon and need to pack up, so this is likely the last thing I can do..
>>
>> It is indeed the nl80211 part that causes problems, so I guess we're
>> back to an actual ath9k issue.
>
> Thanks. This is peculiar, but indeed pretty clear on the issue being
> triggered by use of nl80211 instead of WEXT regardless of what the
> actual issue is. I haven't used wpa_supplicant v1.0-rc3 pretty much
> at all myself and there has been quite a few changes in nl80211
> interaction since then. Anyway, this should give a good test case with
> the current kernel and that somewhat older version with nl80211
> implementation in wpa_supplicant.
>
>> > In addition, you could try to collect the frames exchanged by the
>> > success and failure cases using a monitor interface:
>> >
>> > iw wlan0 interface add mon0 type monitor
>> > ifconfig mon0 up
>> > dumpcap -i mon0 -w /tmp/capture.pkt
>> >
>> > And then run the success/failure case.
>>
>> Ok, will try to do that too.
>
> If you'll get a chance to do that, it would be quite helpful since it
> could make it easier to try to reproduce this if there is indeed
> something special about that AP behavior that allows the issue to show
> up but does not show up in the wpa_supplicant debug log.
>
> --
> Jouni Malinen                                            PGP id EFC895FA
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
