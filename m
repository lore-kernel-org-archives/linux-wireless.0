Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:49549 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab2IAFLe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2012 01:11:34 -0400
MIME-Version: 1.0
In-Reply-To: <1345536267-9449-1-git-send-email-ming.lei@canonical.com>
References: <1345536267-9449-1-git-send-email-ming.lei@canonical.com>
Date: Sat, 1 Sep 2012 13:11:32 +0800
Message-ID: <CACVXFVPX1NB5uJ6yXkNbDWoX4OVdYfRU_=tsWC529-tH+3WfDA@mail.gmail.com> (sfid-20120901_071223_988055_DB2A20B1)
Subject: Re: [PATCH -next v1] wireless: ath9k-htc: only load firmware in need
From: Ming Lei <ming.lei@canonical.com>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, Ming Lei <ming.lei@canonical.com>,
	ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 21, 2012 at 4:04 PM, Ming Lei <ming.lei@canonical.com> wrote:
> It is not necessary to hold the firmware memory during the whole
> driver lifetime, and obviously it does waste memory. Suppose there
> are 4 ath9k-htc usb dongles working, kernel has to consume about
> 4*50KBytes RAM to cache firmware for all dongles. After applying the
> patch, kernel only caches one single firmware image in RAM for
> all ath9k-htc devices just during system suspend/resume cycle.
>
> When system is ready for loading firmware, ath9k-htc can request
> the loading from usersapce. During system resume, ath9k-htc still
> can load the firmware which was cached in kernel memory before
> system suspend.
>
> Cc: ath9k-devel@lists.ath9k.org
> Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
> Cc: Jouni Malinen <jouni@qca.qualcomm.com>
> Cc: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
> Cc: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
> Cc: "John W. Linville" <linville@tuxdriver.com>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
> v1:
>         fix double free of firmware in failue path of
>         ath9k_hif_usb_firmware_cb

Gentle ping, :-)


Thanks,
--
Ming Lei
