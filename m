Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f179.google.com ([209.85.220.179]:41626 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092AbaJHMRP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 08:17:15 -0400
Received: by mail-vc0-f179.google.com with SMTP id im17so6544574vcb.38
        for <linux-wireless@vger.kernel.org>; Wed, 08 Oct 2014 05:17:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20141008111258.GD25666@qca.qualcomm.com>
References: <1412759786-10567-1-git-send-email-rmanohar@qti.qualcomm.com>
	<CA+BoTQ=K=F5TodrmuaEaJfErFx1=BL-bmPDrAaeMLjjb8c3fJQ@mail.gmail.com>
	<20141008103312.GA25666@qca.qualcomm.com>
	<CA+BoTQmVsyuxjvc_s-BC6ZwRWk3ACG0CvDYHJRnZ7OqY6W1Upw@mail.gmail.com>
	<20141008110842.GC25666@qca.qualcomm.com>
	<20141008111258.GD25666@qca.qualcomm.com>
Date: Wed, 8 Oct 2014 14:17:14 +0200
Message-ID: <CA+BoTQmub2V+smwVyRV-qr-6RZUs+=HQTdLX0+AUBp9wyUYw0g@mail.gmail.com> (sfid-20141008_141718_842661_B742429E)
Subject: Re: [PATCH] ath10k: fix kernel panic while shutting down AP
From: Michal Kazior <michal.kazior@tieto.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 October 2014 13:13, Rajkumar Manoharan <rmanohar@qti.qualcomm.com> wrote:
> On Wed, Oct 08, 2014 at 04:38:44PM +0530, Rajkumar Manoharan wrote:
>> On Wed, Oct 08, 2014 at 12:50:28PM +0200, Michal Kazior wrote:
>> > If anything the offender should be dma_unmap_single() but the thing is
>> > beacon_buf is always allocated for AP/IBSS now which means
>> > dma_unmap_single() is never called. For non-AP/IBSS both arvif->beacon
>> > and arvif->beacon_buf are always NULL so neither
>> > dma_alloc/free_coherent nor dma_map/unmap_single are called.
>> >
>> Agree. We need one more check in ath10k_mac_vif_beacon_free.
>
> No additional check is needed. For non beaconing mode, arvif->beacon
> should be false. isn't it?

Correct. No extra checks are necessary.


Michał
