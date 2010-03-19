Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581Ab0CSIsc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 04:48:32 -0400
Date: Fri, 19 Mar 2010 09:46:24 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Cyril Brulebois <kibi@debian.org>, 574526@bugs.debian.org,
	Greg KH <greg@kroah.com>
Subject: Re: Bug#574526: linux-image-2.6.32-4-amd64: iwlagn flood in dmesg:
	free more than tfds_in_queue
Message-ID: <20100319084623.GA27646@dhcp-lab-161.englab.brq.redhat.com>
References: <20100318200535.5639.6476.reportbug@bowmore> <1268961358.18314.43.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1268961358.18314.43.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 19, 2010 at 01:15:58AM +0000, Ben Hutchings wrote:
> On Thu, 2010-03-18 at 21:05 +0100, Cyril Brulebois wrote:
> > Package: linux-2.6
> > Version: 2.6.32-10
> > Severity: normal
> > 
> > Hi,
> > 
> > it looks like the following upstream commits lead to those repeated
> > messages, as soon as there's some traffic on the wireless network:
> > | [ 3538.284491] iwlagn 0000:02:00.0: free more than tfds_in_queue (1:2)
> > | [ 3538.285838] iwlagn 0000:02:00.0: free more than tfds_in_queue (1:2)
> > | [ 3538.286666] iwlagn 0000:02:00.0: free more than tfds_in_queue (1:2)
> > | [ 3538.298152] iwlagn 0000:02:00.0: free more than tfds_in_queue (0:2)
> > | [ 3538.299241] iwlagn 0000:02:00.0: free more than tfds_in_queue (1:2)
> > 
> > master   : a120e912eb51e347f36c71b60a1d13af74d30e83
> > 2.6.32.y : 44af042e42f2231579ea8ef7586d3789d198f609
> > 
> > | $ git show v2.6.32.9-12-g44af042
> > | commit 44af042e42f2231579ea8ef7586d3789d198f609
> > | Author: Stanislaw Gruszka <sgruszka@redhat.com>
> > | Date:   Fri Feb 19 15:47:33 2010 -0800
> > | 
> > |     iwlwifi: sanity check before counting number of tfds can be free
> [...]
> 
> Stanislaw, do you understand how this is going wrong?  Do you have a
> fix?
> 

It's here: https://patchwork.kernel.org/patch/86722/

I'm really sorry that make this bug during backport to .32.

Stanislaw
