Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756468Ab3FSNKS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 09:10:18 -0400
Date: Wed, 19 Jun 2013 15:12:36 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Lars Zastrow <Lars.Zastrow@gmx.de>
Cc: backports@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: bug-report: Ralink corp. Device [1814:539a] - Kernel 3.8 +
Message-ID: <20130619131234.GB2580@redhat.com> (sfid-20130619_151022_393316_224350DB)
References: <51BE8008.20302@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51BE8008.20302@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 17, 2013 at 05:18:32AM +0200, Lars Zastrow wrote:
> Dear Team,
> 
> I'am using the following wireless-network-device:
> 
> Network controller [0280]: Ralink corp. Device [1814:539a]
> Subsystem: Hewlett-Packard Company Device [103c:1839]
> Kernel driver in use: rt2800pci
> 
> I had problems with it since I bought my laptop... The driver was
> unstable with the kernel I used back in autumn 2012. Howeverer, one
> kernel-update fixed it. Must be something about 3.4x?
> 
> It was defenetly working with the Kernels from 3.5 till 3.7 on
> multible distros. 3.8 was bringing back the old Problems:
> 
> - extremly low signal
> - hard to establish a connection to any acess-point.
> 
> The last "problematic" kernel I have testet was 3.9.5-1 on
> Arch-Linux. Compiling the compat-drivers manually did not bring any
> fix.
> 
> I am currently using 3.7.4-1 wich is working.

This most likely is a RT5390 TX power problem I made on 3.8.

This patch should help:
https://git.kernel.org/cgit/linux/kernel/git/linville/wireless.git/commit/?id=8c8d2017ba25c510ddf093419048460db1109bc4

Stanislaw
