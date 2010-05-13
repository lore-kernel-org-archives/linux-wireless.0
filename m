Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38043 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab0EMJrf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 05:47:35 -0400
Received: by fxm6 with SMTP id 6so112131fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 May 2010 02:47:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1273743418-28383-10-git-send-email-gwingerde@gmail.com>
References: <1273743418-28383-1-git-send-email-gwingerde@gmail.com>
	 <1273743418-28383-10-git-send-email-gwingerde@gmail.com>
Date: Thu, 13 May 2010 11:47:33 +0200
Message-ID: <AANLkTikLSLA_vCs8Wv5Xpxea406Kcjovp4r10S9BaPce@mail.gmail.com>
Subject: Re: [PATCH v2 09/10] rt2x00: Reverse calling order of bus
	write_tx_desc and driver write_tx_desc.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 13, 2010 at 11:36 AM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> For rt2800 reverse the calling order of rt2x00pci_write_data and
> rt2800pci_write_data. Currently rt2800pci_write_data calls rt2x00pci_write_data
> as there can be only 1 driver callback function specified by the driver.
> Reverse this calling order by introducing a new driver callback function,
> called write_tx_datadesc, which is called from the bus-specific write_tx_data
> functions.
> Preparation for futher cleanups in the skb data handling of rt2x00.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
