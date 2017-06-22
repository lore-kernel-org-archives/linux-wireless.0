Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:14837 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752714AbdFVW3k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 18:29:40 -0400
Date: Fri, 23 Jun 2017 00:29:35 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mateusz Jurczyk <mjurczyk@google.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, security@kernel.org
Subject: Re: [PATCH] nfc: Ensure presence of required attributes in the
 activate_target netlink handler
Message-ID: <20170622222935.GF21214@zurbaran.ger.intel.com> (sfid-20170623_002957_603870_0B0827D3)
References: <20170524104226.14841-1-mjurczyk@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170524104226.14841-1-mjurczyk@google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mateusz,

On Wed, May 24, 2017 at 12:42:26PM +0200, Mateusz Jurczyk wrote:
> Check that the NFC_ATTR_TARGET_INDEX and NFC_ATTR_PROTOCOLS attributes (in
> addition to NFC_ATTR_DEVICE_INDEX) are provided by the netlink client
> prior to accessing them. This prevents potential unhandled NULL pointer
> dereference exceptions which can be triggered by malicious user-mode
> programs, if they omit one or both of these attributes.
> 
> Signed-off-by: Mateusz Jurczyk <mjurczyk@google.com>
> ---
>  net/nfc/netlink.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
Applied, thanks.

Cheers,
Samuel.
