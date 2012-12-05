Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:42233 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab2LEMFa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 07:05:30 -0500
Received: by mail-we0-f174.google.com with SMTP id x10so2002548wey.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Dec 2012 04:05:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50BF322A.900@openwrt.org>
References: <1354042885-32688-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	<1354042885-32688-4-git-send-email-siwu@hrz.tu-chemnitz.de>
	<CAJ-VmommX5JZMZtpmyOSzOZ1Y7YtdsizwpAFMzzCrQ3238RkEw@mail.gmail.com>
	<20121205104008.GA29382@pandem0nium>
	<50BF322A.900@openwrt.org>
Date: Wed, 5 Dec 2012 04:05:29 -0800
Message-ID: <CAJ-Vmok+D8vZE3BBZL5CwkegSpe9Sxi0OSzJmTeO8HA6Om4kcQ@mail.gmail.com> (sfid-20121205_130534_279141_659074E4)
Subject: Re: [RFC 3/3] ath9k: add spectral scan feature
From: Adrian Chadd <adrian@freebsd.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	kgiori@qca.qualcomm.com, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5 December 2012 03:38, Felix Fietkau <nbd@openwrt.org> wrote:

> How about using relay (Documentation/filesystems/relay.txt) to stream
> sample data to user space via the debugfs file?
> That way you don't have to keep a linked list of small struct fft_sample
> buffers in the kernel and you can stream much more data efficiently with
> little kernel side overhead.
> It also makes pushing the streaming data to a network socket via
> sendfile much more efficient.

Yes, please do this.

When *cough* I do this for FreeBSD, I'll just have people expose this
via BPF. I already have code to pull radar PHY errors out via BPF, so
this becomes just as trivial to do.



Adrian
