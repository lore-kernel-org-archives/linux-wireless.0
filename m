Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:41205 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbaEMSVm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2014 14:21:42 -0400
Received: by mail-ig0-f173.google.com with SMTP id hn18so5536697igb.0
        for <linux-wireless@vger.kernel.org>; Tue, 13 May 2014 11:21:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140513104141.GA14670@qca.qualcomm.com>
References: <1399447378-31503-1-git-send-email-dh.herrmann@gmail.com>
	<20140507195435.GF20432@tuxdriver.com>
	<536A9479.8010201@openwrt.org>
	<20140512174910.GM17022@tuxdriver.com>
	<53711646.1030909@openwrt.org>
	<CANq1E4Seak3MoBVdQTV7afFHQWmir14DJCQe_knjhC8szp4EhA@mail.gmail.com>
	<20140513090056.GA31546@qca.qualcomm.com>
	<CANq1E4QY+mSeMJx0ctWvAdmrsONCFaD+6268HnuowMKOM2FdFQ@mail.gmail.com>
	<20140513104141.GA14670@qca.qualcomm.com>
Date: Tue, 13 May 2014 20:21:42 +0200
Message-ID: <CANq1E4SEUhD9z_YrH6VT7CiFpC2t=QM5dHFaGuq8OLQ3atOCzA@mail.gmail.com> (sfid-20140513_202145_926606_FD4E4935)
Subject: Re: [ath9k-devel] [PATCH] ath9k: fix NULL-deref in
 hw_per_calibration() for ar9002
From: David Herrmann <dh.herrmann@gmail.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	ath9k-devel@venema.h4ckr.net,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Tue, May 13, 2014 at 12:41 PM, Rajkumar Manoharan
<rmanohar@qti.qualcomm.com> wrote:
> On Tue, May 13, 2014 at 11:09:48AM +0200, David Herrmann wrote:
> Unlike ath9k driver, the ani work is stopped in sw_scan_start callback
> for htc driver. So during scan process, ani work is stopped well before
> calling set_channel. But in case of p2p_listen operation, set_channel can be
> called by sw_roc without stopping ani.
>
> Can you please test with attached change?

I cannot reproduce it anymore and my traces show that the
recalibration is called a _lot_ less often. In fact, during 10
successful p2p-connect attempts the per_calib helper is only called
once.

I will keep looking, but looks good so far:
Tested-by: David Herrmann <dh.herrmann@gmail.com>

Thanks
David
