Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36693 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab0ICWiA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Sep 2010 18:38:00 -0400
Date: Fri, 3 Sep 2010 19:38:01 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: linux-pcmcia@lists.infradead.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-usb@vger.kernel.org, laforge@gnumonks.org,
	linux-mtd@lists.infradead.org, linux-bluetooth@vger.kernel.org,
	alsa-devel@alsa-project.org, linux-serial@vger.kernel.org,
	Jiri Kosina <jkosina@suse.cz>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 10/15] pcmcia: introduce autoconfiguration feature
Message-ID: <20100903223801.GG16973@vigoh>
References: <20100903105628.GA21255@comet.dominikbrodowski.net>
 <1283511434-21620-10-git-send-email-linux@dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1283511434-21620-10-git-send-email-linux@dominikbrodowski.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Dominik Brodowski <linux@dominikbrodowski.net> [2010-09-03 12:57:09 +0200]:

> Introduce an autoconfiguration feature to set certain values in
> pcmcia_loop_config(), instead of copying the same code over and over
> in each PCMCIA driver. At first, introduce the following options:
> 
> CONF_AUTO_CHECK_VCC	check or matching Vcc entry
> CONF_AUTO_SET_VPP	set Vpp
> CONF_AUTO_AUDIO		enable the speaker line
> 
> CC: netdev@vger.kernel.org
> CC: linux-wireless@vger.kernel.org
> CC: linux-ide@vger.kernel.org
> CC: linux-usb@vger.kernel.org
> CC: laforge@gnumonks.org
> CC: linux-mtd@lists.infradead.org
> CC: linux-bluetooth@vger.kernel.org
> CC: alsa-devel@alsa-project.org
> CC: linux-serial@vger.kernel.org
> CC: Jiri Kosina <jkosina@suse.cz>
> CC: linux-scsi@vger.kernel.org
> Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
> ---
>  drivers/ata/pata_pcmcia.c                        |   23 +----
>  drivers/bluetooth/bt3c_cs.c                      |    7 +-
>  drivers/bluetooth/btuart_cs.c                    |    7 +-
>  drivers/bluetooth/dtl1_cs.c                      |    1 -
>  drivers/char/pcmcia/cm4000_cs.c                  |    1 -
>  drivers/char/pcmcia/cm4040_cs.c                  |    1 -
>  drivers/char/pcmcia/ipwireless/main.c            |    1 -
>  drivers/char/pcmcia/synclink_cs.c                |    1 -
>  drivers/ide/ide-cs.c                             |   23 +----
>  drivers/isdn/hardware/avm/avm_cs.c               |    1 -
>  drivers/isdn/hisax/avma1_cs.c                    |    1 -
>  drivers/isdn/hisax/elsa_cs.c                     |    1 -
>  drivers/isdn/hisax/sedlbauer_cs.c                |   25 +-----
>  drivers/isdn/hisax/teles_cs.c                    |    1 -
>  drivers/net/pcmcia/axnet_cs.c                    |    1 -
>  drivers/net/pcmcia/fmvj18x_cs.c                  |    1 -
>  drivers/net/pcmcia/pcnet_cs.c                    |    1 -
>  drivers/net/pcmcia/smc91c92_cs.c                 |    2 -
>  drivers/net/pcmcia/xirc2ps_cs.c                  |    5 +-
>  drivers/net/wireless/airo_cs.c                   |   17 +---
>  drivers/net/wireless/atmel_cs.c                  |   17 +---
>  drivers/net/wireless/hostap/hostap_cs.c          |   27 +-----
>  drivers/net/wireless/libertas/if_cs.c            |    1 -
>  drivers/net/wireless/orinoco/orinoco_cs.c        |   31 +------
>  drivers/net/wireless/orinoco/spectrum_cs.c       |   24 +----
>  drivers/parport/parport_cs.c                     |    1 -
>  drivers/pcmcia/pcmcia_cis.c                      |   36 ++++++-
>  drivers/scsi/pcmcia/aha152x_stub.c               |    1 -
>  drivers/scsi/pcmcia/fdomain_stub.c               |    1 -
>  drivers/scsi/pcmcia/nsp_cs.c                     |  110 ++++++++-------------
>  drivers/scsi/pcmcia/qlogic_stub.c                |    1 -
>  drivers/scsi/pcmcia/sym53c500_cs.c               |    1 -
>  drivers/serial/serial_cs.c                       |   10 +--
>  drivers/staging/comedi/drivers/cb_das16_cs.c     |    1 -
>  drivers/staging/comedi/drivers/das08_cs.c        |    1 -
>  drivers/staging/comedi/drivers/ni_daq_700.c      |   10 +--
>  drivers/staging/comedi/drivers/ni_daq_dio24.c    |   10 +--
>  drivers/staging/comedi/drivers/ni_labpc_cs.c     |   11 +--
>  drivers/staging/comedi/drivers/ni_mio_cs.c       |    1 -
>  drivers/staging/comedi/drivers/quatech_daqp_cs.c |    1 -
>  drivers/telephony/ixj_pcmcia.c                   |    1 -
>  drivers/usb/host/sl811_cs.c                      |   24 +----
>  include/pcmcia/ds.h                              |    7 +-
>  43 files changed, 120 insertions(+), 329 deletions(-)

For drivers/bluetooth

Acked-by: Gustavo F. Padovan <padovan@profusion.mobi>

-- 
Gustavo F. Padovan
ProFUSION embedded systems - http://profusion.mobi
