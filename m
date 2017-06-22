Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:38995 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753846AbdFVW10 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 18:27:26 -0400
Date: Fri, 23 Jun 2017 00:27:17 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mateusz Jurczyk <mjurczyk@google.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, security@kernel.org
Subject: Re: [PATCH] nfc: Fix the sockaddr length sanitization in
 llcp_sock_connect
Message-ID: <20170622222717.GE21214@zurbaran.ger.intel.com> (sfid-20170623_002756_186595_1D5CA1EC)
References: <20170524102620.13806-1-mjurczyk@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170524102620.13806-1-mjurczyk@google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mateusz,

On Wed, May 24, 2017 at 12:26:20PM +0200, Mateusz Jurczyk wrote:
> Fix the sockaddr length verification in the connect() handler of NFC/LLCP
> sockets, to compare against the size of the actual structure expected on
> input (sockaddr_nfc_llcp) instead of its shorter version (sockaddr_nfc).
> 
> Both structures are defined in include/uapi/linux/nfc.h. The fields
> specific to the _llcp extended struct are as follows:
> 
>    276		__u8 dsap; /* Destination SAP, if known */
>    277		__u8 ssap; /* Source SAP to be bound to */
>    278		char service_name[NFC_LLCP_MAX_SERVICE_NAME]; /* Service name URI */;
>    279		size_t service_name_len;
> 
> If the caller doesn't provide a sufficiently long sockaddr buffer, these
> fields remain uninitialized (and they currently originate from the stack
> frame of the top-level sys_connect handler). They are then copied by
> llcp_sock_connect() into internal storage (nfc_llcp_sock structure), and
> could be subsequently read back through the user-mode getsockname()
> function (handled by llcp_sock_getname()). This would result in the
> disclosure of up to ~70 uninitialized bytes from the kernel stack to
> user-mode clients capable of creating AFC_NFC sockets.
> 
> Signed-off-by: Mateusz Jurczyk <mjurczyk@google.com>
> ---
>  net/nfc/llcp_sock.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
Applied to nfc-next, thanks.

Cheers,
Samuel.
