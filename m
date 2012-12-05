Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:38095 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031Ab2LELiZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 06:38:25 -0500
Message-ID: <50BF322A.900@openwrt.org> (sfid-20121205_123829_059718_46730CD4)
Date: Wed, 05 Dec 2012 12:38:18 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
CC: Adrian Chadd <adrian@freebsd.org>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, johannes@sipsolutions.net,
	ath9k-devel@lists.ath9k.org, rodrigue@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, kgiori@qca.qualcomm.com,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [RFC 3/3] ath9k: add spectral scan feature
References: <1354042885-32688-1-git-send-email-siwu@hrz.tu-chemnitz.de> <1354042885-32688-4-git-send-email-siwu@hrz.tu-chemnitz.de> <CAJ-VmommX5JZMZtpmyOSzOZ1Y7YtdsizwpAFMzzCrQ3238RkEw@mail.gmail.com> <20121205104008.GA29382@pandem0nium>
In-Reply-To: <20121205104008.GA29382@pandem0nium>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-12-05 11:40 AM, Simon Wunderlich wrote:
>> I suggest experimenting around with those particular parameters. You
>> should be able to coax out specific numbers of spectral scan events
>> when you set the COUNT parameter to something other than 8. But
>> polling that bit isn't needed. It should be asynchronous.
> 
> As I said, on AR9220 it appears I get 8 samples when doing setting 
> AR_PHY_SPECTRAL_SCAN_COUNT to 8 (plus maybe some other "stuff"/non-samples).
> On AR9380 I'm not so sure. Probably need to play with it a little
> more. Also, I don't know what "SHORT REPEAT" is supposed to mean, etc.
> 
> About polling, you mean the SCAN_ACTIVE bit? It is probably only
> needed when I want to trigger for few samples and want to be informed when
> it's finished -  which is a good thing when doing spectral scan (change channel,
> start and wait for samples, change again). But we probably don't need to wait
> for the "background spectral scanning" mode, that's right. If someone wants
> to implement detection for interfering radio users, that mode would be useful.
> I don't need it, but can prepare the neccesary functions.
> 
> So I'd repost then:
>  * ath9k/debugfs only patch for now, as Johannes suggested - I think we
>    should concentrate on this for now (their are still a lot of open
>    questions in my initial mail regarding sample interpretation etc)
>  * split commands into enable/disable/configure/trigger
>  * maybe add some defines for magic values (if I find any)
> 
> I'd like this patchset to make the graphical spectral scan possible (as
> a Ubiquiti Airview), and give others the opportunity to add own features
> (pattern matching etc) on top of it. However I (currently) don't plan to
> do the latter myself.
How about using relay (Documentation/filesystems/relay.txt) to stream
sample data to user space via the debugfs file?
That way you don't have to keep a linked list of small struct fft_sample
buffers in the kernel and you can stream much more data efficiently with
little kernel side overhead.
It also makes pushing the streaming data to a network socket via
sendfile much more efficient.

- Felix
