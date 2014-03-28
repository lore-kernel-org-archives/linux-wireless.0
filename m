Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:46678 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbaC1Nxl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 09:53:41 -0400
Received: by mail-we0-f176.google.com with SMTP id x48so2624692wes.21
        for <linux-wireless@vger.kernel.org>; Fri, 28 Mar 2014 06:53:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140328132849.31620.78501.stgit@potku.adurom.net>
References: <20140328132849.31620.78501.stgit@potku.adurom.net>
Date: Fri, 28 Mar 2014 14:53:40 +0100
Message-ID: <CA+BoTQmqf8kryKEeD00P6o+N7C+980pEqHnT9qe4H4cjZ+eb=w@mail.gmail.com> (sfid-20140328_145347_623285_FA29805B)
Subject: Re: [PATCH v5] ath10k: implement per-VDEV FW statistics
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 March 2014 14:28, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> From: Bartosz Markowski <bartosz.markowski@tieto.com>
>
> The WMI_REQUEST_PEER_STAT command with latest (999.999.0.716) FW
> can return per-VDEV statistics. Using debugfs we can fetch this info now.
>
> This is a backward compatible change. In case of older FW the VDEV
> statistics are simply not returned.
>
> kvalo: remove struct wmi_peer_stats_common cast from
> ath10k_debug_read_target_stats()

I just glanced over the patch and I don't think this is correct.

Firmware 10.1.467 has peer_rx_rate but doesn't seem to have vdev stats.


Michał
