Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:36263 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756894Ab3DPMKd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Apr 2013 08:10:33 -0400
Message-ID: <516D3FB2.7070005@neratec.com> (sfid-20130416_141039_322172_F7E4D165)
Date: Tue, 16 Apr 2013 14:10:26 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch] ath9k: use GFP_ATOMIC under spinlock
References: <20130416075128.GB1571@elgon.mountain>
In-Reply-To: <20130416075128.GB1571@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/16/2013 09:51 AM, Dan Carpenter wrote:
> This is called with spinlocks held so we have to use GFP_ATOMIC.  It's
> the sc_pcu_lock in ath9k_stop() that's the issue.  The call tree looks
> like this:
> 
> ath9k_stop()
> ath_prepare_reset()
> ath_stoprecv()
> ath_flushrecv()
> ath_rx_tasklet()
> ath9k_dfs_process_phyerr()
> pd->add_pulse() => dpd_add_pulse()
> channel_detector_get()
> channel_detector_create()
> pri_detector_init()
> 
> channel_detector_create() uses GFP_ATOMIC as well.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Static analysis stuff.  I haven't tested this but it looks like a real
> bug to me.
> 
Thanks Dan,

it is a bug that slipped through the related patch in [1].


Tested-by & Acked-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>



[1] http://article.gmane.org/gmane.linux.kernel.wireless.general/106349/
