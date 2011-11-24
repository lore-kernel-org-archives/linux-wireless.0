Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755212Ab1KXMv0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 07:51:26 -0500
Date: Thu, 24 Nov 2011 13:54:15 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Pedro Francisco <pedrogfrancisco@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwl3945 firmware errors: tentative debugging
Message-ID: <20111124125414.GA8077@redhat.com> (sfid-20111124_135130_545362_3D3ACB9B)
References: <CAJZjf_xDm_RaFqxF-r+MAPyh_HcCb+yV4dNrfhr+LH0-z2zk8g@mail.gmail.com>
 <CAJZjf_yEBb3BEf+-Fei78xBmJT1Y_Jr5fPUJNKwi6kvuVg24KA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAJZjf_yEBb3BEf+-Fei78xBmJT1Y_Jr5fPUJNKwi6kvuVg24KA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Pedro

On Thu, Nov 24, 2011 at 11:49:30AM +0000, Pedro Francisco wrote:
> iwl3945 has had firmware errors triggered 'by' NM after started using
> nl80211 instead of wext. Since Intel has stopped supporting iwl3945,
> no firmware fix has been possible. It has been workarounded by
> disable_hw_scan=1 as default, with the penalty of network performance
> being lower and frequent 'hangs' on the connection.
Eh, we changed to software scan by default for workaround various
problems. Unfortunately that is causing other problems for other
users. For now, do not exist best default disable_hw_scan= value, that
would pleased everyone :-(

> I was able to trigger the firmware error by doing "iw dev wlan0 scan
> passive". By comparison, "iw dev wlan0 scan" does NOT trigger the
> firmware error.

> Having activated firmware debugging, it would seem a firmware error
> occurs when a full passive scan is done. If all channels 1-140 are
> scanned passively, a firmware error occurs. If at least one of those
> channels is actively scanned, no error occurs.
> 
> Where should I look next?
Good finding, I'm able to reproduce that firmware error too. Perhaps
you could install older kernel ie. 2.6.32 or even 2.6.24 and see if you
can recreate problem there (but I'm not sure if on older kernel
"iw dev wlan0 scan passive" command will work). If you will find kernel
version, where issue is not present, you might figure out what is
different regarding setting up SCAN command, or let me know so I
will look at that :-) If that is broken also on old kernels, we
perhaps could modify code that will disallow to do all passive
channels scan.

Thanks
Stanislaw
