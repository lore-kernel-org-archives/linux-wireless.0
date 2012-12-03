Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:49630 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab2LCUVj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 15:21:39 -0500
Received: by mail-wg0-f46.google.com with SMTP id dr13so1841262wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 Dec 2012 12:21:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50BD03EF.3010504@01019freenet.de>
References: <20121203115632.GA2490@redhat.com>
	<50BCB3A3.4090708@01019freenet.de>
	<201212031629.16806.chunkeey@googlemail.com>
	<50BD03EF.3010504@01019freenet.de>
Date: Mon, 3 Dec 2012 21:21:38 +0100
Message-ID: <CAGXE3d-MFLsQr1xdWqk0bVdFj2VR+Bspffazaka3NzvWPusLUg@mail.gmail.com> (sfid-20121203_212143_050069_7FCBBDDA)
Subject: Re: [PATCH 1/2] mac80211: introduce IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Francisco Pina Martins <f.pinamartins@gmail.com>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, Dec 3, 2012 at 8:56 PM, Andreas Hartmann
<andihartmann@01019freenet.de> wrote:
> Christian Lamparter wrote:
>> On Monday, December 03, 2012 03:13:55 PM Andreas Hartmann wrote:
>>> Stanislaw Gruszka wrote:
>>>> Commit f0425beda4d404a6e751439b562100b902ba9c98 "mac80211: retry sending
>>>> failed BAR frames later instead of tearing down aggr" caused regression
>>>> on rt2x00 hardware (connection hangs).
>>>
>>> This patch caused a problem, too, with carl9170
>>> (http://thread.gmane.org/gmane.linux.kernel.wireless.general/92203/focus=92376).
>>> How did they fix it (the thread unfortunately ends without any solution
>>> / patch).
>>
>> This was fixed by: carl9170: fix HT peer BA session corruption
>> (c9122c0d63a50 in wireless-testing). The issue here is that the
>> hardware does not set the tx success bit when it receives a
>> BA for a sent BAR [looks like it is expecting a legacy ACK?!
>> but who knows - the original vendor driver [otus] didn't really
>> deal with BARs anyway].
>
> If I got Helmut correctly here
> (http://news.gmane.org/find-root.php?group=gmane.linux.kernel.wireless.general&article=83762),
> rt2x00pci could have a related problem (probably missing tx status).
>
> Wouldn't it be an idea to try a similar approach?
>
> https://kernel.googlesource.com/pub/scm/linux/kernel/git/linville/wireless-testing/+/c9122c0d63a50bab0a97dc936a38c0f921b6930e^!/

Yep, this makes definitely sense! And since we can copy big parts of
the carl9170 patch :D this shouldn't be too much work hopefully ...

Helmut
