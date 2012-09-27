Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44733 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab2I0Var (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 17:30:47 -0400
Date: Thu, 27 Sep 2012 17:24:35 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Subject: Re: [PATCH -next] wireless: ath9k-htc: fix possible use after free
Message-ID: <20120927212435.GA1892@tuxdriver.com> (sfid-20120927_233051_484395_1DBB3CF8)
References: <1347503608-3521-1-git-send-email-ming.lei@canonical.com>
 <CACVXFVOkTNOtk6_nxG4CgcgZX5iLCiuSusxvbBpn43F1=L=X2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CACVXFVOkTNOtk6_nxG4CgcgZX5iLCiuSusxvbBpn43F1=L=X2g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 27, 2012 at 12:06:17PM +0800, Ming Lei wrote:
> On Thu, Sep 13, 2012 at 10:33 AM, Ming Lei <ming.lei@canonical.com> wrote:
> > Inside ath9k_hif_usb_firmware_fail(), the instance of
> > 'struct struct hif_device_usb' may be freed by
> > ath9k_hif_usb_disconnect() after
> >
> >         complete(&hif_dev->fw_done);
> >
> > But 'hif_dev' is still accessed after the line code
> > above is executed.
> >
> > This patch fixes the issue by not accessing 'hif_dev'
> > after 'complete(&hif_dev->fw_done)' inside
> > ath9k_hif_usb_firmware_fail().
> >
> > Cc: ath9k-devel@lists.ath9k.org
> > Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
> > Cc: Jouni Malinen <jouni@qca.qualcomm.com>
> > Cc: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
> > Cc: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
> > Cc: "John W. Linville" <linville@tuxdriver.com>
> 
> Gentle ping, :-)

This is commit e962610f8100e1b52973f5a9c855cbc3d1ba04ec in wireless-next?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
