Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:34232 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728458AbeHNMl6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 08:41:58 -0400
Date: Tue, 14 Aug 2018 12:54:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: security@kernel.org, kdeus@google.com,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Allen Pais <allen.pais@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] NFC: Fix possible memory corruption when handling
 SHDLC I-Frame commands
Message-ID: <20180814095413.vbjkcjkmytkffyaz@mwanda> (sfid-20180814_115547_874348_464D8FF9)
References: <20180813223910.26276-1-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180813223910.26276-1-surenb@google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks.  This is great.  I'm so glad these are finally getting fixed.

Do we need to fix nfc_hci_msg_rx_work() and nfc_hci_recv_from_llc() as
well?  In nfc_hci_recv_from_llc() we allow pipe to be NFC_HCI_FRAGMENT
(0x7f) so that's one element beyond the end of the array and the
NFC_HCI_HCP_RESPONSE isn't checked.

Also nci_hci_msg_rx_work() and nci_hci_data_received_cb() use
NCI_HCP_MSG_GET_PIPE() so those could be off by one.

regards,
dan carpenter
