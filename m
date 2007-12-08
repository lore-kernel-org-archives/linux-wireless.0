Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:55237 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756107AbXLHImk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Dec 2007 03:42:40 -0500
Received: by nf-out-0910.google.com with SMTP id g13so501125nfb
        for <linux-wireless@vger.kernel.org>; Sat, 08 Dec 2007 00:42:39 -0800 (PST)
Message-ID: <475A58F9.2080009@gmail.com> (sfid-20071208_084242_870853_E3617507)
Date: Sat, 08 Dec 2007 09:42:33 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: bruno randolf <bruno@thinktube.com>
CC: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, mcgrof@gmail.com, mickflemm@gmail.com
Subject: Re: [PATCH 1/1] ath5k: add debugfs entries for registers, tsf, beacon
References: <1196839665-14178-1-git-send-email-bruno@thinktube.com> <47566B95.5080101@gmail.com> <200712051950.08672.bruno@thinktube.com>
In-Reply-To: <200712051950.08672.bruno@thinktube.com>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/05/2007 11:50 AM, bruno randolf wrote:
[...]
> +static int open_file_registers(struct inode *inode, struct file *file)
> +{
> +	struct seq_file *s;
> +	int res;
> +	res = seq_open(file, &register_seq_ops);
> +	s = (struct seq_file *)file->private_data;

you don't need to cast here (from void *).

> +	s->private = inode->i_private;
> +	return res;
> +}
> +
> +static const struct file_operations fops_registers = {

BTW. to prevent removing the module while having opened this debug stuff, you
should add:
.owner = THIS_MODULE,

> +	.open = open_file_registers,
> +	.read    = seq_read,
> +	.llseek  = seq_lseek,
> +	.release = seq_release
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

and here

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
> +	REG_PRINT_APPEND(AR5K_TIMER3);
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

and here.

> +	.read = read_file_beacon,
> +	.write = write_file_beacon,
> +	.open = ath5k_debugfs_open,
> +};
> +
> +
> +/* debugfs: reset */
> +
> +static ssize_t write_file_reset(struct file *file,
> +				 const char __user *userbuf,
> +				 size_t count, loff_t *ppos)
> +{
> +	struct ath5k_softc *sc = file->private_data;
> +	tasklet_schedule(&sc->restq);
> +	return count;
> +}
> +
> +static const struct file_operations fops_reset = {

and here :)

> +	.write = write_file_reset,
> +	.open = ath5k_debugfs_open,
> +};

thanks,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
