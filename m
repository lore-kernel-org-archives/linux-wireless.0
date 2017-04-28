Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:57607 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1164786AbdD1H3c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Apr 2017 03:29:32 -0400
Date: Fri, 28 Apr 2017 09:29:04 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Shikha SINGH <shikha.singh@st.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-nfc@lists.01.org" <linux-nfc@lists.01.org>,
        Raunaque Mujeeb QUAISER <raunaque.quaiser@st.com>,
        Manoj KUMAR <manoj.kumar@st.com>,
        Sylvain FIDELIS <sylvain.fidelis@st.com>,
        Raphael COLLADO <Raphael.COLLADO@st.com>
Subject: Re: [[linux-nfc] PATCH v1.0 0/6] Support for ST NFC Transceiver
Message-ID: <20170428072904.GC3717@zurbaran.ger.intel.com> (sfid-20170428_092938_605669_390D9D8D)
References: <1469161579-4339-1-git-send-email-shikha.singh@st.com>
 <ad22efa9cb8c443eaa0828e25c0b207a@SFHDAG2NODE3.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ad22efa9cb8c443eaa0828e25c0b207a@SFHDAG2NODE3.st.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Shikha,

That one is next on my review list.
Could you please rebase it on top of nfc-next though ?

Cheers,
Samuel.

On Fri, Apr 28, 2017 at 04:31:16AM +0000, Shikha SINGH wrote:
> Hello Samuel,
>        Could you please consider the below patch series for integration in Linux-NFC mainline?
> A long time ago we released this patch series but did not get any review comments or update.
> 
> This release is important for our customers who always prefer to pick the release from mainline.
>  
> Thanks for your comments.
> 
> Thanks & Regards,
> Shikha
> 
> >>-----Original Message-----
> >>From: Shikha SINGH
> >>Sent: Friday, July 22, 2016 9:56 AM
> >>To: sameo@linux.intel.com; linux-nfc@lists.01.org
> >>Cc: Raunaque Mujeeb QUAISER <raunaque.quaiser@st.com>; Manoj
> >KUMAR
> >><manoj.kumar@st.com>; Sylvain FIDELIS <sylvain.fidelis@st.com>; Patrick
> >>SOHN <patrick.sohn@st.com>; Shikha SINGH <shikha.singh@st.com>;
> >Raphael
> >>COLLADO <Raphael.COLLADO@st.com>
> >>Subject: [[linux-nfc] PATCH v1.0 0/6] Support for ST NFC Transceiver
> >>
> >>*** STMicrolectronics NFC v1.0 ***
> >>This patch series introduces the following features:
> >>
> >>(a) A generic Digital NFC UART framework.
> >>The framework itself is an LDISC registered with the tty core. Any NFC
> >>transciever implementing the digital specs and connected on an UART (or
> >>on an emulated tty, such as /dev/ttyUSBx, /dev/ttyACMx) interface with
> >>the host, will require this support.
> >>
> >>(b) An ST NFC Transciever core framework. This implements the required
> >>digital ops and exposes an interface for the underlying phy drivers
> >>(UART/ SPI). The services of the phy drivers are required when the core
> >>wants to transmit/receive frames.
> >>Also it provides helper functions for the phy drivers, for example phy
> >>drivers registers with the core when it detects a Transciever connected
> >>on the corresponding interface.
> >>The framework currently supports NFC Type 2, Type 4A, Type 4B, Type 5
> >>tag read/write.
> >>
> >>(c) An ST NFC UART LDisc driver that registers with the Digital NFC
> >>UART framework, and with the ST NFC Transciever core framework as the
> >>UART Phy driver.
> >>
> >>(d) An ST NFC SPI driver that register with ST NFC Transceiver core
> >>framework as SPI phy driver.
> >>
> >>(e) This patch series also removes all the references of old ST NFC
> >>transceiver driver "st95hf".
> >>
> >>Shikha Singh (6):
> >>  NFC: add generic UART support
> >>  NFC: nfcst: Add ST NFC Transceiver core framework
> >>  NFC: nfctst: Add UART LDisc Driver
> >>  NFC: nfctst: Add ST NFC SPI Driver
> >>  DT: bindings: net: nfc: stnfc binding doc
> >>  DRIVERS: NFC: Remove st95hf
> >>
> >> .../devicetree/bindings/net/nfc/st95hf.txt         |   50 -
> >> .../devicetree/bindings/net/nfc/stnfc.txt          |   50 +
> >> drivers/nfc/Kconfig                                |    2 +-
> >> drivers/nfc/Makefile                               |    2 +-
> >> drivers/nfc/nfcst/Kconfig                          |   48 +
> >> drivers/nfc/nfcst/Makefile                         |   12 +
> >> drivers/nfc/nfcst/core.c                           | 1122 +++++++++++++++++
> >> drivers/nfc/nfcst/spi.c                            |  492 ++++++++
> >> drivers/nfc/nfcst/stnfcdev.h                       |   70 ++
> >> drivers/nfc/nfcst/uart.c                           |  164 +++
> >> drivers/nfc/st95hf/Kconfig                         |   10 -
> >> drivers/nfc/st95hf/Makefile                        |    6 -
> >> drivers/nfc/st95hf/core.c                          | 1273 --------------------
> >> drivers/nfc/st95hf/spi.c                           |  167 ---
> >> drivers/nfc/st95hf/spi.h                           |   64 -
> >> include/net/nfc/digital_uart.h                     |  105 ++
> >> include/uapi/linux/tty.h                           |    1 +
> >> net/nfc/Kconfig                                    |   12 +
> >> net/nfc/Makefile                                   |    3 +
> >> net/nfc/digital_uart.c                             |  523 ++++++++
> >> 20 files changed, 2604 insertions(+), 1572 deletions(-)  delete mode
> >>100644 Documentation/devicetree/bindings/net/nfc/st95hf.txt
> >> create mode 100644 Documentation/devicetree/bindings/net/nfc/stnfc.txt
> >> create mode 100644 drivers/nfc/nfcst/Kconfig  create mode 100644
> >>drivers/nfc/nfcst/Makefile  create mode 100644 drivers/nfc/nfcst/core.c
> >>create mode 100644 drivers/nfc/nfcst/spi.c  create mode 100644
> >>drivers/nfc/nfcst/stnfcdev.h  create mode 100644
> >>drivers/nfc/nfcst/uart.c delete mode 100644 drivers/nfc/st95hf/Kconfig
> >>delete mode 100644 drivers/nfc/st95hf/Makefile  delete mode 100644
> >>drivers/nfc/st95hf/core.c delete mode 100644 drivers/nfc/st95hf/spi.c
> >>delete mode 100644 drivers/nfc/st95hf/spi.h  create mode 100644
> >>include/net/nfc/digital_uart.h create mode 100644
> >>net/nfc/digital_uart.c
> >>
> >>--
> >>1.9.1
> 
