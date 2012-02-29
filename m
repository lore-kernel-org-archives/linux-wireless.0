Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from foo.stuge.se ([212.116.89.98]:33906 "HELO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965299Ab2B2SJf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 13:09:35 -0500
Message-ID: <20120229180929.32495.qmail@stuge.se> (sfid-20120229_190938_862753_20CAC969)
Date: Wed, 29 Feb 2012 19:09:29 +0100
From: Peter Stuge <peter@stuge.se>
To: Matt Chen <machen@suse.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Subject: Re: [ath9k-devel] Any recommendation of direct access the GPIO
	from specific address ?
References: <CALx5=V8BDFXD7KGBFia0MAkb2iv3x5dupGXTkKEDJ24DLJVx1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALx5=V8BDFXD7KGBFia0MAkb2iv3x5dupGXTkKEDJ24DLJVx1g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matt Chen wrote:
> So it would detect the GPIO status in every 5 seconds. But the ath9k I
> run in different platform, with the same modules, it works different
> way. The LED for one is working very fast, in another one is working
> so slow.
> 
> I would like to clarify it is driver or BIOS issues.

It sounds like a hardware issue, meaning on the mainboard. Some
designs signal the kernel about rfkill directly, others do not. When
the design does not signal the kernel, the kernel only discovers it
after 5 seconds when the ath9k driver looks at it's GPIO pin.


//Peter
