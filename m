Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55927 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894Ab2AZPxH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 10:53:07 -0500
Message-ID: <4F2176DE.9010604@openwrt.org> (sfid-20120126_165312_472272_186BB207)
Date: Thu, 26 Jan 2012 16:53:02 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
CC: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	rodrigue@qca.qualcomm.com, adrian.chadd@gmail.com,
	kgiori@qca.qualcomm.com, shafi.wireless@gmail.com
Subject: Re: [RFC 1/2] ath9k: add DFS pattern detector
References: <1327592044-3319-1-git-send-email-zefir.kurtisi@neratec.com> <1327592044-3319-2-git-send-email-zefir.kurtisi@neratec.com>
In-Reply-To: <1327592044-3319-2-git-send-email-zefir.kurtisi@neratec.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-01-26 4:34 PM, Zefir Kurtisi wrote:
> This adds a DFS pattern detector to the common ath module. It takes
> pulse events reported by ath9k and reports in place whether a
> pattern was detected. On detection, caller must report a radar event
> to the DFS management component in the upper layer.
> 
> Currently the ETSI DFS domain is supported with detector lines for
> the patterns defined by EN-301-893 v1.5.1. Support for FCC and JP
> will be added gradually.
> 
> The detector is independent of the underlying HW, but located in
> the ath driver since so far it is used by ath9k only. It might
> move up to mac80211 as soon as other non-Atheros drivers start
> using it.
> 
> NOTE: since DFS requires some more components on different layers
> that are currently missing, the detector is not functionally
> integrated yet. When ath9k is build with a certified DFS config
> option, the detector is included in ath.ko. All it does there is
> wasting kernel memory and waiting to be used by ath9k.
> 
> USAGE: to use the detector, wiphy drivers must
>  - use dfs_pattern_detector.h as interface
>  - have a struct dfs_pattern_detector *dpd per wiphy
>  - on wiphy creation, instantiate a detector with
>    dpd = dfs_pattern_detector_init(enum dfs_domain)
>  - forward any radar pulse detected to dpd->add_pulse()
>  - report radar event if add_pulse() returns RADAR_DETECTED
>  - on wiphy destruction call dpd->exit()
> 
> Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
> ---
>  drivers/net/wireless/ath/Makefile                  |   10 +
>  .../ath/dfs_pattern_detector/detector_elem.c       |   92 ++++++
>  .../ath/dfs_pattern_detector/detector_elem.h       |   45 +++
>  .../dfs_pattern_detector/dfs_pattern_detector.h    |   92 ++++++
>  .../ath/dfs_pattern_detector/pattern_detector.c    |  294 ++++++++++++++++++++
>  .../ath/dfs_pattern_detector/pulse_queue.c         |  168 +++++++++++
>  .../ath/dfs_pattern_detector/pulse_queue.h         |   77 +++++
>  .../ath/dfs_pattern_detector/pulse_sequence.c      |  280 +++++++++++++++++++
>  .../ath/dfs_pattern_detector/pulse_sequence.h      |   89 ++++++
>  .../ath/dfs_pattern_detector/radar_types.c         |   52 ++++
>  .../ath/dfs_pattern_detector/radar_types.h         |   95 +++++++
>  .../net/wireless/ath/dfs_pattern_detector/utils.c  |   45 +++
>  .../net/wireless/ath/dfs_pattern_detector/utils.h  |   30 ++
>  13 files changed, 1369 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/detector_elem.c
>  create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/detector_elem.h
>  create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/dfs_pattern_detector.h
>  create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/pattern_detector.c
>  create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/pulse_queue.c
>  create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/pulse_queue.h
>  create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/pulse_sequence.c
>  create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/pulse_sequence.h
>  create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/radar_types.c
>  create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/radar_types.h
>  create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/utils.c
>  create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/utils.h
> 
> diff --git a/drivers/net/wireless/ath/Makefile b/drivers/net/wireless/ath/Makefile
> index d716b74..10f9554 100644
> --- a/drivers/net/wireless/ath/Makefile
> +++ b/drivers/net/wireless/ath/Makefile
> @@ -11,4 +11,14 @@ ath-objs :=	main.o \
>  		key.o
>  
>  ath-$(CONFIG_ATH_DEBUG) += debug.o
> +
> +# include DFS pattern detector if we have certified HW
> +ath-$(CONFIG_ATH9K_DFS_CERTIFIED)	+= \
> +			dfs_pattern_detector/pulse_queue.o \
> +			dfs_pattern_detector/pulse_sequence.o \
> +			dfs_pattern_detector/detector_elem.o \
> +			dfs_pattern_detector/pattern_detector.o \
> +			dfs_pattern_detector/radar_types.o \
> +			dfs_pattern_detector/utils.o
> +
>  ccflags-y += -D__CHECK_ENDIAN__
> diff --git a/drivers/net/wireless/ath/dfs_pattern_detector/pattern_detector.c b/drivers/net/wireless/ath/dfs_pattern_detector/pattern_detector.c
> new file mode 100644
> index 0000000..2d634fe
> --- /dev/null
> +++ b/drivers/net/wireless/ath/dfs_pattern_detector/pattern_detector.c
> @@ -0,0 +1,294 @@
[...]
> +/**
> + * struct pattern_detector - overloading base dfs_pattern_detector
> + *
> + * @exit(): destructor
> + * @add_pulse(): add radar pulse to detector
> + * @num_radar_types: number of different radar types
> + * @last_pulse_ts: time stamp of last valid pulse
> + * @radar_detector_specs: array of radar detection specs
> + * @channel_detectors: list connecting channel_detector elements
> + */
> +struct pattern_detector {
> +	void (*exit)(struct pattern_detector *_this);
> +	enum dfs_detector_result (*add_pulse)
> +		(struct pattern_detector *_this, struct pulse_event *pe);
> +
> +	u8 num_radar_types;
> +	u64 last_pulse_ts;
> +	struct radar_detector_specs *radar_spec;
> +	struct list_head channel_detectors;
> +};
To overload it this way is quite fragile. It's better to embed struct
dfs_pattern_detector here. In places where you need to go from the
struct dfs_pattern_detector to this struct, you can then use the
container_of macro, to get at least some form of type safety.

- Felix
