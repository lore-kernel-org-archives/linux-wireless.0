Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:15092 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbZCPTSO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 15:18:14 -0400
MIME-Version: 1.0
In-Reply-To: <43e72e890903161215u343cbb19v6d6cbf36794e252a@mail.gmail.com>
References: <43e72e890903161215u343cbb19v6d6cbf36794e252a@mail.gmail.com>
Date: Mon, 16 Mar 2009 12:18:12 -0700
Message-ID: <43e72e890903161218o6896e58bqadc7e80f6a975bc0@mail.gmail.com> (sfid-20090316_201816_996059_14F9C4FF)
Subject: Re: AMD Quad core - PCI-DMA: Out of IOMMU space on > 4 GB RAM
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: wireless <linux-wireless@vger.kernel.org>, joerg.roedel@amd.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	iommu@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 16, 2009 at 12:15 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> I've run into "PCI-DMA: Out of IOMMU space" messages after loading and
> unloading a module 30 times. The interesting thing is this only
> happens if I have > 4 GB of memory. The box this occurs has AMD Phenom
> quad core CPU so I take it a harware IOMMU is being used. Below are
> example relevant messages with > 4 GB and then < 4 GB of memory. The
> driver I tested this with was ath9k. It could be an issue perhaps with
> ath9k but I am unable to find an issue in our probe/removal.
>
> Could this be an issue with the AMD IOMMU used? Or is it more likely a
> driver issue?

I forgot to mention I'm using l Linus 2.6.29-rc8 with some
serialization patches applied for ath9k (which are unrelated to
DMA/IOMMU/probe) [1].

http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/2009-03-12/serialization-v6/for-2.6.29/

  Luis
