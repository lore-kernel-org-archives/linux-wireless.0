Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coyote.holtmann.net ([212.227.132.17]:59673 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750819AbdEBG6s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 May 2017 02:58:48 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [linux-nfc] [[PATCH v1] 0/6] Support of ST NFC Transceiver
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1493705023-8710-1-git-send-email-shikha.singh@st.com>
Date: Tue, 2 May 2017 08:58:45 +0200
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-nfc@lists.01.org, manoj.kumar@st.com, sylvain.fidelis@st.com,
        raphael.collado@st.com, MMS_MMY_Applications_SW@list.st.com,
        Rob Herring <robh@kernel.org>
Message-Id: <C4E99B67-D95D-46E6-828A-49FFE447272B@holtmann.org> (sfid-20170502_085855_128023_29C78A00)
References: <1493705023-8710-1-git-send-email-shikha.singh@st.com>
To: Shikha Singh <shikha.singh@st.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Shikha,

> *** V1.0 ***
> This patch series is generated on top of latest
> code available on nfc-next.
> 
> This patch series introduces the following features:
> 
> (a) A generic Digital NFC UART framework.
> The framework itself is an LDISC registered
> with the tty core. Any NFC transciever implementing
> the digital specs and connected on an UART
> (or on an emulated tty, such as /dev/ttyUSBx, /dev/ttyACMx)
> interface with the host, will require this support.
> 
> (b) An ST NFC Transciever core framework. This implements the
> required digital ops and exposes an interface for the
> underlying phy drivers (UART/ SPI). The services of the phy drivers
> are required when the core wants to transmit/receive frames.
> Also it provides helper functions for the phy drivers, for
> example phy drivers registers with the core when it detects
> a Transciever connected on the corresponding interface.
> The framework currently supports NFC Type 2, Type 4A, Type 4B,
> Type 5 tag read/write.
> 
> (c) An ST NFC UART LDisc driver that registers with the
> Digital NFC UART framework, and with the ST NFC Transciever
> core framework as the UART Phy driver.

lets stop this please and move towards serdev support. We really do not need more line disciplines for this.

Regards

Marcel
