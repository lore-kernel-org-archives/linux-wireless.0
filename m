Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.244]:2896 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751662AbXLEJNB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2007 04:13:01 -0500
Received: by hs-out-2122.google.com with SMTP id 54so462540hsz
        for <linux-wireless@vger.kernel.org>; Wed, 05 Dec 2007 01:12:59 -0800 (PST)
Message-ID: <47566B95.5080101@gmail.com> (sfid-20071205_091309_017722_B39AB67A)
Date: Wed, 05 Dec 2007 10:12:53 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Bruno Randolf <bruno@thinktube.com>
CC: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, mcgrof@gmail.com, mickflemm@gmail.com
Subject: Re: [PATCH 1/1] ath5k: add debugfs entries for registers, tsf, beacon
References: <1196839665-14178-1-git-send-email-bruno@thinktube.com>
In-Reply-To: <1196839665-14178-1-git-send-email-bruno@thinktube.com>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/05/2007 08:27 AM, Bruno Randolf wrote:
> 'registers' prints the value of some registers. this should be adapted to what
> we actually need later.
> 
> 'tsf' prints the current HW TSF. writing "reset" into the file will reset the
> TSF.
> 
> 'beacon' shows beacon relevant registers. writing "enable" into the file will
> enable beacons by writing AR5K_BEACON_ENABLE, "disable" will disable that bit.
> 
> Changes-licensed-under: GPL
> Signed-off-by: Bruno Randolf <bruno@thinktube.com>
> ---
>  drivers/net/wireless/ath5k/debug.c |  188 ++++++++++++++++++++++++++++++++++++
>  drivers/net/wireless/ath5k/debug.h |    3 +
>  2 files changed, 191 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath5k/debug.c b/drivers/net/wireless/ath5k/debug.c
> index 7427506..8d4fd5f 100644
> --- a/drivers/net/wireless/ath5k/debug.c
> +++ b/drivers/net/wireless/ath5k/debug.c
> @@ -68,8 +68,178 @@ module_param_named(debug, ath5k_debug, uint, 0);
>  
>  #include "reg.h"
>  
> +/* this assumes variables buf for buffer and len for count */
> +#define REG_PRINT_APPEND(_reg) \
> +	len += snprintf(buf+len, sizeof(buf)-len, "%-30s0x%08x\n", #_reg, \
> +		ath5k_hw_reg_read(sc->ah, _reg));
> +
> +
>  static struct dentry *ath5k_global_debugfs;
>  
> +
> +static int ath5k_debugfs_open(struct inode *inode, struct file *file)
> +{
> +	file->private_data = inode->i_private;
> +	return 0;
> +}
> +
> +
> +/* debugfs: registers */
> +
> +static ssize_t read_file_registers(struct file *file, char __user *user_buf,
> +				   size_t count, loff_t *ppos)
> +{
> +	struct ath5k_softc *sc = file->private_data;
> +
> +	char buf[5000];

Doh, 4k stacks on i386! You can't do this safely.

I think we can use seq_* stuff here instead, see below.

> +	int len = 0;
> +
> +	/* just a few random registers, might want to add more */
> +	REG_PRINT_APPEND(AR5K_CR);
> +	REG_PRINT_APPEND(AR5K_RXDP);
> +	REG_PRINT_APPEND(AR5K_CFG);
> +	REG_PRINT_APPEND(AR5K_IER);
> +	REG_PRINT_APPEND(AR5K_BCR);
> +	REG_PRINT_APPEND(AR5K_RTSD0);
> +	REG_PRINT_APPEND(AR5K_RTSD1);
> +	REG_PRINT_APPEND(AR5K_TXCFG);
> +	REG_PRINT_APPEND(AR5K_RXCFG);
> +	REG_PRINT_APPEND(AR5K_RXJLA);
> +	REG_PRINT_APPEND(AR5K_MIBC);
> +	REG_PRINT_APPEND(AR5K_TOPS);
> +	REG_PRINT_APPEND(AR5K_RXNOFRM);
> +	REG_PRINT_APPEND(AR5K_TXNOFRM);
> +	REG_PRINT_APPEND(AR5K_RPGTO);
> +	REG_PRINT_APPEND(AR5K_RFCNT);
> +	REG_PRINT_APPEND(AR5K_MISC);
> +	REG_PRINT_APPEND(AR5K_QCUDCU_CLKGT);
> +
> +	REG_PRINT_APPEND(AR5K_ISR);
> +	REG_PRINT_APPEND(AR5K_PISR);
> +	REG_PRINT_APPEND(AR5K_SISR0);
> +	REG_PRINT_APPEND(AR5K_SISR1);
> +	REG_PRINT_APPEND(AR5K_SISR2);
> +	REG_PRINT_APPEND(AR5K_SISR3);
> +	REG_PRINT_APPEND(AR5K_SISR4);
> +	REG_PRINT_APPEND(AR5K_IMR);
> +	REG_PRINT_APPEND(AR5K_PIMR);
> +	REG_PRINT_APPEND(AR5K_SIMR0);
> +	REG_PRINT_APPEND(AR5K_SIMR1);
> +	REG_PRINT_APPEND(AR5K_SIMR2);
> +	REG_PRINT_APPEND(AR5K_SIMR3);
> +	REG_PRINT_APPEND(AR5K_SIMR4);
> +
> +	REG_PRINT_APPEND(AR5K_DCM_ADDR);
> +	REG_PRINT_APPEND(AR5K_DCCFG);
> +	REG_PRINT_APPEND(AR5K_CCFG);
> +	REG_PRINT_APPEND(AR5K_CPC0);
> +	REG_PRINT_APPEND(AR5K_CPC1);
> +	REG_PRINT_APPEND(AR5K_CPC2);
> +	REG_PRINT_APPEND(AR5K_CPC3);
> +	REG_PRINT_APPEND(AR5K_CPCORN);
> +
> +	REG_PRINT_APPEND(AR5K_RESET_CTL);
> +	REG_PRINT_APPEND(AR5K_SLEEP_CTL);
> +	REG_PRINT_APPEND(AR5K_INTPEND);
> +	REG_PRINT_APPEND(AR5K_SFR);
> +	REG_PRINT_APPEND(AR5K_PCICFG);
> +	REG_PRINT_APPEND(AR5K_GPIOCR);
> +	REG_PRINT_APPEND(AR5K_GPIODO);
> +	REG_PRINT_APPEND(AR5K_SREV);

Put those register in the array, and from .seq_next, return &array[++*pos] or
NULL for the last member. .seq_show will contain the REG_PRINT_APPEND macro
contents.

> +
> +	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
> +}
> +
> +static const struct file_operations fops_registers = {
> +	.read = read_file_registers,
> +	.open = ath5k_debugfs_open,
> +};
> +
> +
> +/* debugfs: TSF */
> +
> +static ssize_t read_file_tsf(struct file *file, char __user *user_buf,
> +				   size_t count, loff_t *ppos)
> +{
> +	struct ath5k_softc *sc = file->private_data;
> +	char buf[100];
> +	snprintf(buf, 100, "0x%016llx\n", ath5k_hw_get_tsf64(sc->ah));
> +	return simple_read_from_buffer(user_buf, count, ppos, buf, 19);
> +}
> +
> +static ssize_t write_file_tsf(struct file *file,
> +				 const char __user *userbuf,
> +				 size_t count, loff_t *ppos)
> +{
> +	struct ath5k_softc *sc = file->private_data;
> +	if (strncmp(userbuf, "reset", 5) == 0) {
> +		ath5k_hw_reset_tsf(sc->ah);
> +		printk(KERN_INFO "debugfs reset TSF\n");
> +	}
> +	return count;
> +}
> +
> +static const struct file_operations fops_tsf = {
> +	.read = read_file_tsf,
> +	.write = write_file_tsf,
> +	.open = ath5k_debugfs_open,
> +};
> +
> +
> +/* debugfs: beacons */
> +
> +static ssize_t read_file_beacon(struct file *file, char __user *user_buf,
> +				   size_t count, loff_t *ppos)
> +{
> +	struct ath5k_softc *sc = file->private_data;
> +	struct ath5k_hw *ah = sc->ah;
> +
> +	char buf[1000];
> +	int len = 0;
> +	REG_PRINT_APPEND(AR5K_BEACON);
> +	len += snprintf(buf+len, 1000-len, "\tbeacon period:\t%d\n",
> +		ath5k_hw_reg_read(ah, AR5K_BEACON) & AR5K_BEACON_PERIOD);
> +	len += snprintf(buf+len, 1000-len, "\tbeacon tim:\t%x\n",
> +		(ath5k_hw_reg_read(ah, AR5K_BEACON) & AR5K_BEACON_TIM)
> +		>> AR5K_BEACON_TIM_S);
> +	len += snprintf(buf+len, 1000-len, "\tbeacons enabled: %s\n",
> +		ath5k_hw_reg_read(ah, AR5K_BEACON) & AR5K_BEACON_ENABLE ?
> +			"YES" : "NO");
> +	REG_PRINT_APPEND(AR5K_TIMER0);
> +	REG_PRINT_APPEND(AR5K_TIMER1);
> +	REG_PRINT_APPEND(AR5K_TIMER2);
> +	REG_PRINT_APPEND(AR5K_LAST_TSTP);
> +	REG_PRINT_APPEND(AR5K_BEACON_CNT);
> +
> +	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
> +}
> +
> +static ssize_t write_file_beacon(struct file *file,
> +				 const char __user *userbuf,
> +				 size_t count, loff_t *ppos)
> +{
> +	struct ath5k_softc *sc = file->private_data;
> +	struct ath5k_hw *ah = sc->ah;
> +
> +	if (strncmp(userbuf, "disable", 7) == 0) {
> +		AR5K_REG_DISABLE_BITS(ah, AR5K_BEACON, AR5K_BEACON_ENABLE);
> +		printk(KERN_INFO "debugfs disable beacons\n");
> +	} else if (strncmp(userbuf, "enable", 6) == 0) {
> +		AR5K_REG_ENABLE_BITS(ah, AR5K_BEACON, AR5K_BEACON_ENABLE);
> +		printk(KERN_INFO "debugfs enable beacons\n");
> +	}
> +	return count;
> +}
> +
> +static const struct file_operations fops_beacon = {
> +	.read = read_file_beacon,
> +	.write = write_file_beacon,
> +	.open = ath5k_debugfs_open,
> +};
> +
> +
> +/* init */
> +
>  void
>  ath5k_debug_init(void)
>  {
> @@ -84,6 +254,18 @@ ath5k_debug_init_device(struct ath5k_softc *sc)
>  			ath5k_global_debugfs);
>  	sc->debug.debugfs_debug = debugfs_create_u32("debug",
>  			0666, sc->debug.debugfs_phydir, &sc->debug.level);
> +
> +	sc->debug.debugfs_registers = debugfs_create_file("registers", 0444,
> +				sc->debug.debugfs_phydir,
> +				sc, &fops_registers);
> +
> +	sc->debug.debugfs_tsf = debugfs_create_file("tsf", 0666,
> +				sc->debug.debugfs_phydir,
> +				sc, &fops_tsf);
> +
> +	sc->debug.debugfs_beacon = debugfs_create_file("beacon", 0666,
> +				sc->debug.debugfs_phydir,
> +				sc, &fops_beacon);
>  }
>  
>  void
> @@ -96,9 +278,15 @@ void
>  ath5k_debug_finish_device(struct ath5k_softc *sc)
>  {
>  	debugfs_remove(sc->debug.debugfs_debug);
> +	debugfs_remove(sc->debug.debugfs_registers);
> +	debugfs_remove(sc->debug.debugfs_tsf);
> +	debugfs_remove(sc->debug.debugfs_beacon);
>  	debugfs_remove(sc->debug.debugfs_phydir);
>  }
>  
> +
> +/* functions used in other places */
> +
>  void
>  ath5k_debug_dump_modes(struct ath5k_softc *sc, struct ieee80211_hw_mode *modes)
>  {
> diff --git a/drivers/net/wireless/ath5k/debug.h b/drivers/net/wireless/ath5k/debug.h
> index 115073f..b640147 100644
> --- a/drivers/net/wireless/ath5k/debug.h
> +++ b/drivers/net/wireless/ath5k/debug.h
> @@ -77,6 +77,9 @@ struct ath5k_dbg_info {
>  	/* debugfs entries */
>  	struct dentry		*debugfs_phydir;
>  	struct dentry		*debugfs_debug;
> +	struct dentry		*debugfs_registers;
> +	struct dentry		*debugfs_tsf;
> +	struct dentry		*debugfs_beacon;
>  };
>  
>  /**


-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
