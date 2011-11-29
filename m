Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39243 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab1K2RIQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 12:08:16 -0500
Received: by vbbfc26 with SMTP id fc26so4946896vbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Nov 2011 09:08:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111124125414.GA8077@redhat.com>
References: <CAJZjf_xDm_RaFqxF-r+MAPyh_HcCb+yV4dNrfhr+LH0-z2zk8g@mail.gmail.com>
 <CAJZjf_yEBb3BEf+-Fei78xBmJT1Y_Jr5fPUJNKwi6kvuVg24KA@mail.gmail.com> <20111124125414.GA8077@redhat.com>
From: Pedro Francisco <pedrogfrancisco@gmail.com>
Date: Tue, 29 Nov 2011 17:07:55 +0000
Message-ID: <CAJZjf_zM2zBsoh66KcRwgi-jS7DF-qH5-sKrUoCB=hFTPES7LA@mail.gmail.com> (sfid-20111129_180820_603219_3B1238B4)
Subject: Re: iwl3945 firmware errors: tentative debugging
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My country has the following regulatory.bin lines:

country PT:	(2402.000 - 2482.000 @ 40.000), (N/A, 20.00)	(5170.000 -
5250.000 @ 40.000), (N/A, 20.00)	(5250.000 - 5330.000 @ 40.000), (N/A,
20.00), DFS <------ removed whole line	(5490.000 - 5710.000 @ 40.000),
(N/A, 27.00), DFS <------ removed whole line

If I remove the last two lines, everything works as expected, i.e., NO
"Microsode SW error". If I include any of the last two, the Microcode
will issue an error.

I've tried every combination of those lines except just one of
"(5250.000 - 5330.000 @ 40.000), (N/A, 20.00), DFS" OR "(5490.000 -
5710.000 @ 40.000), (N/A, 27.00), DFS".

Next week I'll look at the source code.
On Thu, Nov 24, 2011 at 12:54 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Hi Pedro
>
> On Thu, Nov 24, 2011 at 11:49:30AM +0000, Pedro Francisco wrote:
>> iwl3945 has had firmware errors triggered 'by' NM after started using
>> nl80211 instead of wext. Since Intel has stopped supporting iwl3945,
>> no firmware fix has been possible. It has been workarounded by
>> disable_hw_scan=1 as default, with the penalty of network performance
>> being lower and frequent 'hangs' on the connection.
> Eh, we changed to software scan by default for workaround various
> problems. Unfortunately that is causing other problems for other
> users. For now, do not exist best default disable_hw_scan= value, that
> would pleased everyone :-(
>
>> I was able to trigger the firmware error by doing "iw dev wlan0 scan
>> passive". By comparison, "iw dev wlan0 scan" does NOT trigger the
>> firmware error.
>
>> Having activated firmware debugging, it would seem a firmware error
>> occurs when a full passive scan is done. If all channels 1-140 are
>> scanned passively, a firmware error occurs. If at least one of those
>> channels is actively scanned, no error occurs.
>>
>> Where should I look next?
> Good finding, I'm able to reproduce that firmware error too. Perhaps
> you could install older kernel ie. 2.6.32 or even 2.6.24 and see if you
> can recreate problem there (but I'm not sure if on older kernel
> "iw dev wlan0 scan passive" command will work). If you will find kernel
> version, where issue is not present, you might figure out what is
> different regarding setting up SCAN command, or let me know so I
> will look at that :-) If that is broken also on old kernels, we
> perhaps could modify code that will disallow to do all passive
> channels scan.
>
> Thanks
> Stanislaw
