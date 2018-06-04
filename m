Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:20732 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751061AbeFDE3B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Jun 2018 00:29:01 -0400
Date: Mon, 4 Jun 2018 06:29:00 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Andrey Konovalov <andreyknvl@google.com>
Cc: "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>
Subject: Re: [PATCH] NFC: fix attrs checks in netlink interface
Message-ID: <20180604042900.GB31498@zurbaran.ger.intel.com> (sfid-20180604_062935_452109_C1C9268D)
References: <75ce3040b4086ffa2d2e088ad7f24f5e4a87be56.1523552145.git.andreyknvl@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <75ce3040b4086ffa2d2e088ad7f24f5e4a87be56.1523552145.git.andreyknvl@google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andrey,

On Thu, Apr 12, 2018 at 06:56:56PM +0200, Andrey Konovalov wrote:
> nfc_genl_deactivate_target() relies on the NFC_ATTR_TARGET_INDEX
> attribute being present, but doesn't check whether it is actually
> provided by the user. Same goes for nfc_genl_fw_download() and
> NFC_ATTR_FIRMWARE_NAME.
> 
> This patch adds appropriate checks.
> 
> Found with syzkaller.
> 
> Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> ---
>  net/nfc/netlink.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
Thanks, applied to nfc-next.

Cheers,
Samuel.
