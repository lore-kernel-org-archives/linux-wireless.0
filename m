Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:27144 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbbIOBRo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2015 21:17:44 -0400
Subject: Re: [PATCH 2/2] staging: wilc1000: remove RX_BH_TYPE
To: <gregkh@linuxfoundation.org>
References: <1441957983-17726-1-git-send-email-tony.cho@atmel.com>
 <1441957983-17726-2-git-send-email-tony.cho@atmel.com>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
From: Tony Cho <tony.cho@atmel.com>
Message-ID: <55F771B5.50702@atmel.com> (sfid-20150915_031749_012272_27BD81A2)
Date: Tue, 15 Sep 2015 10:17:41 +0900
MIME-Version: 1.0
In-Reply-To: <1441957983-17726-2-git-send-email-tony.cho@atmel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Greg,

I am sorry but please ignore this patch in this time.

It's my mistake to include this patch from my queue into the series of 7 patches.

Thanks,

Tony.


On 2015년 09월 11일 16:52, Tony Cho wrote:
> This patch removes the preprocessor definition, RX_BH_TYPE and uses the
> request_threaded_irq instead of kernel thread to execute the interrupt
> handler.
>
> As a result, linux_wlan_enable_irq() and linux_wlan_disable_irq() are also
> removed from the linux_wlan.c file.
>
> Signed-off-by: Tony Cho <tony.cho@atmel.com>
> ---
>   drivers/staging/wilc1000/linux_wlan.c         | 148 +-------------------------
>   drivers/staging/wilc1000/linux_wlan_common.h  |   3 -
>   drivers/staging/wilc1000/wilc_wfi_netdevice.h |  16 ---
>   drivers/staging/wilc1000/wilc_wlan.c          |   3 -
>   4 files changed, 2 insertions(+), 168 deletions(-)
>
> diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
> index 9be0282..7265f93 100644
> --- a/drivers/staging/wilc1000/linux_wlan.c
> +++ b/drivers/staging/wilc1000/linux_wlan.c
> @@ -300,89 +300,31 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
>   }
>   #endif
>   
> -/*
> - *	Interrupt initialization and handling functions
> - */
> -
> -void linux_wlan_enable_irq(void)
> -{
> -
> -#if (RX_BH_TYPE != RX_BH_THREADED_IRQ)
> -#if (defined WILC_SPI) || (defined WILC_SDIO_IRQ_GPIO)
> -	PRINT_D(INT_DBG, "Enabling IRQ ...\n");
> -	enable_irq(g_linux_wlan->dev_irq_num);
> -#endif
> -#endif
> -}
> -
> -void linux_wlan_disable_irq(int wait)
> -{
> -#if (defined WILC_SPI) || (defined WILC_SDIO_IRQ_GPIO)
> -	if (wait) {
> -		PRINT_D(INT_DBG, "Disabling IRQ ...\n");
> -		disable_irq(g_linux_wlan->dev_irq_num);
> -	} else {
> -		PRINT_D(INT_DBG, "Disabling IRQ ...\n");
> -		disable_irq_nosync(g_linux_wlan->dev_irq_num);
> -	}
> -#endif
> -}
> -
>   #if (defined WILC_SPI) || (defined WILC_SDIO_IRQ_GPIO)
>   static irqreturn_t isr_uh_routine(int irq, void *user_data)
>   {
> -#if (RX_BH_TYPE != RX_BH_THREADED_IRQ)
> -	linux_wlan_disable_irq(IRQ_NO_WAIT);
> -#endif
>   	PRINT_D(INT_DBG, "Interrupt received UH\n");
>   
>   	/*While mac is closing cacncel the handling of any interrupts received*/
>   	if (g_linux_wlan->close) {
>   		PRINT_ER("Driver is CLOSING: Can't handle UH interrupt\n");
> -	#if (RX_BH_TYPE == RX_BH_THREADED_IRQ)
>   		return IRQ_HANDLED;
> -	#else
> -		return IRQ_NONE;
> -	#endif
> -
>   	}
> -#if (RX_BH_TYPE == RX_BH_WORK_QUEUE)
> -	schedule_work(&g_linux_wlan->rx_work_queue);
> -	return IRQ_HANDLED;
> -#elif (RX_BH_TYPE == RX_BH_KTHREAD)
> -	up(&g_linux_wlan->rx_sem);
> -	return IRQ_HANDLED;
> -#elif (RX_BH_TYPE == RX_BH_THREADED_IRQ)
>   	return IRQ_WAKE_THREAD;
> -#endif
>   
>   }
>   #endif
>   
> -#if (RX_BH_TYPE == RX_BH_WORK_QUEUE || RX_BH_TYPE == RX_BH_THREADED_IRQ)
> -
> -#if (RX_BH_TYPE == RX_BH_THREADED_IRQ)
>   irqreturn_t isr_bh_routine(int irq, void *userdata)
>   {
>   	linux_wlan_t *nic;
>   
>   	nic = (linux_wlan_t *)userdata;
> -#else
> -static void isr_bh_routine(struct work_struct *work)
> -{
> -	perInterface_wlan_t *nic;
> -
> -	nic = (perInterface_wlan_t *)container_of(work, linux_wlan_t, rx_work_queue);
> -#endif
>   
>   	/*While mac is closing cacncel the handling of any interrupts received*/
>   	if (g_linux_wlan->close) {
>   		PRINT_ER("Driver is CLOSING: Can't handle BH interrupt\n");
> -	#if (RX_BH_TYPE == RX_BH_THREADED_IRQ)
>   		return IRQ_HANDLED;
> -	#else
> -		return;
> -	#endif
>   	}
>   
>   	PRINT_D(INT_DBG, "Interrupt received BH\n");
> @@ -391,36 +333,8 @@ static void isr_bh_routine(struct work_struct *work)
>   	else
>   		PRINT_ER("wlan_handle_rx_isr() hasn't been initialized\n");
>   
> -#if (RX_BH_TYPE == RX_BH_THREADED_IRQ)
>   	return IRQ_HANDLED;
> -#endif
> -}
> -#elif (RX_BH_TYPE == RX_BH_KTHREAD)
> -static int isr_bh_routine(void *vp)
> -{
> -	linux_wlan_t *nic;
> -
> -	nic = (linux_wlan_t *)vp;
> -
> -	while (1) {
> -		down(&nic->rx_sem);
> -		if (g_linux_wlan->close) {
> -
> -			while (!kthread_should_stop())
> -				schedule();
> -
> -			break;
> -		}
> -		PRINT_D(INT_DBG, "Interrupt received BH\n");
> -		if (g_linux_wlan->oup.wlan_handle_rx_isr != 0)
> -			g_linux_wlan->oup.wlan_handle_rx_isr();
> -		else
> -			PRINT_ER("wlan_handle_rx_isr() hasn't been initialized\n");
> -	}
> -
> -	return 0;
>   }
> -#endif
>   
>   #if (defined WILC_SPI) || (defined WILC_SDIO_IRQ_GPIO)
>   static int init_irq(linux_wlan_t *p_nic)
> @@ -446,17 +360,10 @@ static int init_irq(linux_wlan_t *p_nic)
>   		PRINT_ER("could not obtain gpio for WILC_INTR\n");
>   	}
>   
> -#if (RX_BH_TYPE == RX_BH_THREADED_IRQ)
>   	if ((ret != -1) && (request_threaded_irq(nic->dev_irq_num, isr_uh_routine, isr_bh_routine,
>   						  IRQF_TRIGGER_LOW | IRQF_ONESHOT,               /*Without IRQF_ONESHOT the uh will remain kicked in and dont gave a chance to bh*/
>   						  "WILC_IRQ", nic)) < 0) {
>   
> -#else
> -	/*Request IRQ*/
> -	if ((ret != -1) && (request_irq(nic->dev_irq_num, isr_uh_routine,
> -					IRQF_TRIGGER_LOW, "WILC_IRQ", nic) < 0)) {
> -
> -#endif
>   		PRINT_ER("Failed to request IRQ for GPIO: %d\n", GPIO_NUM);
>   		ret = -1;
>   	} else {
> @@ -1105,18 +1012,11 @@ void wilc1000_wlan_deinit(linux_wlan_t *nic)
>   #endif
>   
>   		PRINT_D(INIT_DBG, "Disabling IRQ\n");
> -		#if (!defined WILC_SDIO) || (defined WILC_SDIO_IRQ_GPIO)
> -		linux_wlan_disable_irq(IRQ_WAIT);
> -		#else
> -		  #if defined(PLAT_ALLWINNER_A20) || defined(PLAT_ALLWINNER_A23) || defined(PLAT_ALLWINNER_A31)
> -
> -		  #else
> +	#ifdef WILC_SDIO
>   		mutex_lock(&g_linux_wlan->hif_cs);
>   		disable_sdio_interrupt();
>   		mutex_unlock(&g_linux_wlan->hif_cs);
> -		  #endif
> -		#endif
> -
> +	#endif
>   		/* not sure if the following unlocks are needed or not*/
>   		if (&g_linux_wlan->rxq_event != NULL)
>   			up(&g_linux_wlan->rxq_event);
> @@ -1124,16 +1024,6 @@ void wilc1000_wlan_deinit(linux_wlan_t *nic)
>   		if (&g_linux_wlan->txq_event != NULL)
>   			up(&g_linux_wlan->txq_event);
>   
> -	#if (RX_BH_TYPE == RX_BH_WORK_QUEUE)
> -		/*Removing the work struct from the linux kernel workqueue*/
> -		if (&g_linux_wlan->rx_work_queue != NULL)
> -			flush_work(&g_linux_wlan->rx_work_queue);
> -
> -	#elif (RX_BH_TYPE == RX_BH_KTHREAD)
> -		/* if(&nic->rx_sem != NULL) */
> -		/* up(&nic->rx_sem); */
> -	#endif
> -
>   		PRINT_D(INIT_DBG, "Deinitializing Threads\n");
>   		wlan_deinitialize_threads(nic);
>   
> @@ -1193,10 +1083,6 @@ int wlan_init_locks(linux_wlan_t *p_nic)
>   	sema_init(&g_linux_wlan->rxq_thread_started, 0);
>   	sema_init(&g_linux_wlan->txq_thread_started, 0);
>   
> -	#if (RX_BH_TYPE == RX_BH_KTHREAD)
> -	sema_init(&g_linux_wlan->rx_sem, 0);
> -	#endif
> -
>   	return 0;
>   }
>   
> @@ -1274,19 +1160,6 @@ int wlan_initialize_threads(perInterface_wlan_t *nic)
>   
>   	PRINT_D(INIT_DBG, "Initializing Threads ...\n");
>   
> -#if (RX_BH_TYPE == RX_BH_WORK_QUEUE)
> -	/*Initialize rx work queue task*/
> -	INIT_WORK(&g_linux_wlan->rx_work_queue, isr_bh_routine);
> -#elif (RX_BH_TYPE == RX_BH_KTHREAD)
> -	PRINT_D(INIT_DBG, "Creating kthread for Rxq BH\n");
> -	g_linux_wlan->rx_bh_thread = kthread_run(isr_bh_routine, (void *)g_linux_wlan, "K_RXQ_BH");
> -	if (g_linux_wlan->rx_bh_thread == 0) {
> -		PRINT_ER("couldn't create RX BH thread\n");
> -		ret = -ENOBUFS;
> -		goto _fail_;
> -	}
> -#endif
> -
>   #ifndef TCP_ENHANCEMENTS
>   	/* create rx task */
>   	PRINT_D(INIT_DBG, "Creating kthread for reception\n");
> @@ -1333,13 +1206,6 @@ _fail_2:
>   #ifndef TCP_ENHANCEMENTS
>   _fail_1:
>   #endif
> -	#if (RX_BH_TYPE == RX_BH_KTHREAD)
> -	/*De-Initialize 1st thread*/
> -	g_linux_wlan->close = 1;
> -	up(&g_linux_wlan->rx_sem);
> -	kthread_stop(g_linux_wlan->rx_bh_thread);
> -_fail_:
> -	#endif
>   	g_linux_wlan->close = 0;
>   	return ret;
>   }
> @@ -1364,16 +1230,6 @@ static void wlan_deinitialize_threads(linux_wlan_t *nic)
>   		kthread_stop(g_linux_wlan->txq_thread);
>   		g_linux_wlan->txq_thread = NULL;
>   	}
> -
> -	#if (RX_BH_TYPE == RX_BH_KTHREAD)
> -	if (&g_linux_wlan->rx_sem != NULL)
> -		up(&g_linux_wlan->rx_sem);
> -
> -	if (g_linux_wlan->rx_bh_thread != NULL) {
> -		kthread_stop(g_linux_wlan->rx_bh_thread);
> -		g_linux_wlan->rx_bh_thread = NULL;
> -	}
> -	#endif
>   }
>   
>   #ifdef COMPLEMENT_BOOT
> diff --git a/drivers/staging/wilc1000/linux_wlan_common.h b/drivers/staging/wilc1000/linux_wlan_common.h
> index 5d13c15..28bdc40 100644
> --- a/drivers/staging/wilc1000/linux_wlan_common.h
> +++ b/drivers/staging/wilc1000/linux_wlan_common.h
> @@ -168,7 +168,4 @@ extern atomic_t DEBUG_LEVEL;
>   	#define MODALIAS	"WILC_SPI"
>   	#define GPIO_NUM	0x44
>   #endif
> -
> -
> -void linux_wlan_enable_irq(void);
>   #endif
> diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
> index f8064f0..cd80934 100644
> --- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
> +++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
> @@ -70,17 +70,7 @@ struct WILC_WFI_stats {
>    * This structure is private to each device. It is used to pass
>    * packets in and out, so there is place for a packet
>    */
> -
> -#define RX_BH_KTHREAD 0
> -#define RX_BH_WORK_QUEUE 1
> -#define RX_BH_THREADED_IRQ 2
>   #define num_reg_frame 2
> -/*
> - * If you use RX_BH_WORK_QUEUE on LPC3131: You may lose the first interrupt on
> - * LPC3131 which is important to get the MAC start status when you are blocked
> - * inside linux_wlan_firmware_download() which blocks mac_open().
> - */
> - #define RX_BH_TYPE  RX_BH_KTHREAD
>   
>   struct wilc_wfi_key {
>   	u8 *key;
> @@ -197,12 +187,6 @@ typedef struct {
>   	struct semaphore sync_event;
>   	struct semaphore txq_event;
>   
> -#if (RX_BH_TYPE == RX_BH_WORK_QUEUE)
> -	struct work_struct rx_work_queue;
> -#elif (RX_BH_TYPE == RX_BH_KTHREAD)
> -	struct task_struct *rx_bh_thread;
> -	struct semaphore rx_sem;
> -#endif
>   	struct semaphore rxq_thread_started;
>   	struct semaphore txq_thread_started;
>   
> diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
> index 39716ba..44100a5 100644
> --- a/drivers/staging/wilc1000/wilc_wlan.c
> +++ b/drivers/staging/wilc1000/wilc_wlan.c
> @@ -1448,9 +1448,6 @@ void wilc_handle_isr(void)
>   #endif
>   		wilc_unknown_isr_ext();
>   	}
> -#if ((!defined WILC_SDIO) || (defined WILC_SDIO_IRQ_GPIO))
> -	linux_wlan_enable_irq();
> -#endif
>   	release_bus(RELEASE_ALLOW_SLEEP);
>   }
>   

