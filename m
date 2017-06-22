Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:53892 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753611AbdFVWlP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 18:41:15 -0400
Date: Fri, 23 Jun 2017 00:41:11 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mateusz Jurczyk <mjurczyk@google.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfc: Add sockaddr length checks before accessing
 sa_family in bind handlers
Message-ID: <20170622224111.GI21214@zurbaran.ger.intel.com> (sfid-20170623_004235_883165_941A9E4E)
References: <20170613164428.3643-1-mjurczyk@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170613164428.3643-1-mjurczyk@google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 13, 2017 at 06:44:28PM +0200, Mateusz Jurczyk wrote:
> Verify that the caller-provided sockaddr structure is large enough to
> contain the sa_family field, before accessing it in bind() handlers of the
> AF_NFC socket. Since the syscall doesn't enforce a minimum size of the
> corresponding memory region, very short sockaddrs (zero or one byte long)
> result in operating on uninitialized memory while referencing .sa_family.
> 
> Signed-off-by: Mateusz Jurczyk <mjurczyk@google.com>
> ---
>  net/nfc/llcp_sock.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
Applied to nfc-next, thanks.

Cheers,
Samuel.
