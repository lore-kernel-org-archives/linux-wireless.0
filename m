Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33299 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab0ICWf1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Sep 2010 18:35:27 -0400
Date: Fri, 3 Sep 2010 19:35:28 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: linux-pcmcia@lists.infradead.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-usb@vger.kernel.org, laforge@gnumonks.org,
	linux-mtd@lists.infradead.org, linux-bluetooth@vger.kernel.org,
	alsa-devel@alsa-project.org, linux-serial@vger.kernel.org,
	Jiri Kosina <jkosina@suse.cz>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 08/15] pcmcia: convert pcmcia_request_configuration to
 pcmcia_enable_device
Message-ID: <20100903223528.GE16973@vigoh>
References: <20100903105628.GA21255@comet.dominikbrodowski.net>
 <1283511434-21620-8-git-send-email-linux@dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1283511434-21620-8-git-send-email-linux@dominikbrodowski.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Dominik Brodowski <linux@dominikbrodowski.net> [2010-09-03 12:57:07 +0200]:

> pcmcia_enable_device() now replaces pcmcia_request_configuration().
> Instead of config_req_t, all necessary flags are either passed as
> a parameter to pcmcia_enable_device(), or (in rare circumstances)
> set in struct pcmcia_device -> flags.
> 
> With the last remaining user of include/pcmcia/cs.h gone, remove
> all references.
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
>  Documentation/pcmcia/driver-changes.txt          |    6 ++++
>  drivers/ata/pata_pcmcia.c                        |    5 +--
>  drivers/bluetooth/bluecard_cs.c                  |    5 +--
>  drivers/bluetooth/bt3c_cs.c                      |    5 +--
>  drivers/bluetooth/btuart_cs.c                    |    5 +--
>  drivers/bluetooth/dtl1_cs.c                      |    5 +--
>  drivers/char/pcmcia/cm4000_cs.c                  |    3 +-
>  drivers/char/pcmcia/cm4040_cs.c                  |    5 +--
>  drivers/char/pcmcia/ipwireless/main.c            |    6 +--
>  drivers/char/pcmcia/ipwireless/main.h            |    1 -
>  drivers/char/pcmcia/ipwireless/tty.h             |    1 -
>  drivers/char/pcmcia/synclink_cs.c                |   10 ++----
>  drivers/ide/ide-cs.c                             |    6 ++--
>  drivers/isdn/hardware/avm/avm_cs.c               |    5 +--
>  drivers/isdn/hisax/avma1_cs.c                    |    5 +--
>  drivers/isdn/hisax/elsa_cs.c                     |    8 +----
>  drivers/isdn/hisax/sedlbauer_cs.c                |   12 ++-----
>  drivers/isdn/hisax/teles_cs.c                    |    8 ++---
>  drivers/mmc/host/sdricoh_cs.c                    |    1 -
>  drivers/mtd/maps/pcmciamtd.c                     |    6 +---
>  drivers/net/pcmcia/3c574_cs.c                    |    5 +--
>  drivers/net/pcmcia/3c589_cs.c                    |    5 +--
>  drivers/net/pcmcia/axnet_cs.c                    |   10 +++---
>  drivers/net/pcmcia/com20020_cs.c                 |    5 +--
>  drivers/net/pcmcia/fmvj18x_cs.c                  |    5 +--
>  drivers/net/pcmcia/ibmtr_cs.c                    |    5 +--
>  drivers/net/pcmcia/nmclan_cs.c                   |    5 +--
>  drivers/net/pcmcia/pcnet_cs.c                    |    8 ++--
>  drivers/net/pcmcia/smc91c92_cs.c                 |    9 ++---
>  drivers/net/pcmcia/xirc2ps_cs.c                  |   12 ++++----
>  drivers/net/wireless/airo_cs.c                   |   16 ++--------
>  drivers/net/wireless/atmel_cs.c                  |   16 ++--------
>  drivers/net/wireless/b43/pcmcia.c                |    5 +--
>  drivers/net/wireless/hostap/hostap_cs.c          |   10 ++----
>  drivers/net/wireless/libertas/if_cs.c            |   10 ++----
>  drivers/net/wireless/orinoco/orinoco_cs.c        |   12 +------
>  drivers/net/wireless/orinoco/spectrum_cs.c       |   12 +------
>  drivers/net/wireless/ray_cs.c                    |    5 +--
>  drivers/net/wireless/wl3501_cs.c                 |    5 +--
>  drivers/parport/parport_cs.c                     |    5 +--
>  drivers/pcmcia/au1000_generic.h                  |    1 -
>  drivers/pcmcia/au1000_pb1x00.c                   |    1 -
>  drivers/pcmcia/cistpl.c                          |    1 -
>  drivers/pcmcia/cs.c                              |    1 -
>  drivers/pcmcia/cs_internal.h                     |    5 ---
>  drivers/pcmcia/ds.c                              |    3 +-
>  drivers/pcmcia/i82092.c                          |    1 -
>  drivers/pcmcia/i82365.c                          |    1 -
>  drivers/pcmcia/m32r_cfc.c                        |    1 -
>  drivers/pcmcia/m32r_pcc.c                        |    1 -
>  drivers/pcmcia/m8xx_pcmcia.c                     |    1 -
>  drivers/pcmcia/pcmcia_cis.c                      |    1 -
>  drivers/pcmcia/pcmcia_resource.c                 |   33 ++++++++++----------
>  drivers/pcmcia/pd6729.c                          |    1 -
>  drivers/pcmcia/rsrc_iodyn.c                      |    1 -
>  drivers/pcmcia/rsrc_mgr.c                        |    1 -
>  drivers/pcmcia/rsrc_nonstatic.c                  |    1 -
>  drivers/pcmcia/sa1100_generic.c                  |    1 -
>  drivers/pcmcia/soc_common.h                      |    1 -
>  drivers/pcmcia/socket_sysfs.c                    |    1 -
>  drivers/pcmcia/tcic.c                            |    1 -
>  drivers/pcmcia/xxs1500_ss.c                      |    1 -
>  drivers/pcmcia/yenta_socket.c                    |    1 -
>  drivers/scsi/pcmcia/aha152x_stub.c               |    5 +--
>  drivers/scsi/pcmcia/fdomain_stub.c               |    5 +--
>  drivers/scsi/pcmcia/nsp_cs.c                     |   13 +++-----
>  drivers/scsi/pcmcia/qlogic_stub.c                |    7 ++--
>  drivers/scsi/pcmcia/sym53c500_cs.c               |    5 +--
>  drivers/serial/serial_cs.c                       |    9 ++---
>  drivers/ssb/main.c                               |    1 -
>  drivers/ssb/pcmcia.c                             |    1 -
>  drivers/ssb/scan.c                               |    1 -
>  drivers/staging/comedi/drivers/cb_das16_cs.c     |   11 ++-----
>  drivers/staging/comedi/drivers/das08_cs.c        |   17 ++---------
>  drivers/staging/comedi/drivers/ni_daq_700.c      |   19 ++---------
>  drivers/staging/comedi/drivers/ni_daq_dio24.c    |   19 ++---------
>  drivers/staging/comedi/drivers/ni_labpc_cs.c     |   20 +++---------
>  drivers/staging/comedi/drivers/ni_mio_cs.c       |    5 +--
>  drivers/staging/comedi/drivers/quatech_daqp_cs.c |   17 ++---------
>  drivers/staging/wlags49_h2/wl_cs.c               |    7 ++--
>  drivers/staging/wlags49_h2/wl_internal.h         |    1 -
>  drivers/telephony/ixj_pcmcia.c                   |    3 +-
>  drivers/usb/host/sl811_cs.c                      |    7 +---
>  include/pcmcia/cs.h                              |   35 ----------------------
>  include/pcmcia/ds.h                              |   17 +++++++----
>  include/pcmcia/ss.h                              |    1 -
>  sound/pcmcia/pdaudiocf/pdaudiocf.c               |    5 ++-
>  sound/pcmcia/pdaudiocf/pdaudiocf.h               |    1 -
>  sound/pcmcia/vx/vxpocket.c                       |    6 ++--
>  sound/pcmcia/vx/vxpocket.h                       |    1 -
>  90 files changed, 179 insertions(+), 394 deletions(-)
>  delete mode 100644 include/pcmcia/cs.h

For drivers/bluetooth/

Acked-by: Gustavo F. Padovan <padovan@profusion.mobi>

-- 
Gustavo F. Padovan
ProFUSION embedded systems - http://profusion.mobi
