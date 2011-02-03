Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756072Ab1BCKYr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Feb 2011 05:24:47 -0500
Date: Thu, 3 Feb 2011 11:23:33 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Larry.Finger@lwfinger.net
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	zhaoming_li <chaoming_li@realsil.com.cn>
Subject: Re: [PATCH] rtlwifi: rtl8192ce: Modify core for inclusion of
 additional drivers
Message-ID: <20110203102331.GA3516@redhat.com>
References: <1296324761-14158-1-git-send-email-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1296324761-14158-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 29, 2011 at 12:12:41PM -0600, Larry.Finger@lwfinger.net wrote:
> From: zhaoming_li <chaoming_li@realsil.com.cn>

> Unfortunately, this is a much larger patch than I would like, but the
> changes are substantial. I tried to keep any white-space changes to a
> minimum. My attempts to split the patch into separate pieces resulted
> in compilation errors, which would break bisection.

But zhaoming_li did not change code in one big commit like that,
zhaoming_li did you? :-)

It would be better if realsil will send small patches when
they are created, instead of develop driver behind closed doors
and then post changes in one huge hunk.

> +u8 *rtl_find_ie(u8 *data, unsigned int len, u8 ie)
> +{
> +	struct ieee80211_mgmt *mgmt = (void *)data;
> +	u8 *pos, *end;
> +
> +	pos = (u8 *)mgmt->u.beacon.variable;
> +	end = data + len;
> +	while (pos < end) {
> +		if (pos + 2 + pos[1] > end)
> +			return NULL;
> +
> +		if (pos[0] == ie)
> +			return pos;
> +
> +		pos += 2 + pos[1];
> +	}
> +	return NULL;
> +}
[snip]
> +	if ((memcmp(mac->bssid, ap5_1, 3) == 0) ||
> +		(memcmp(mac->bssid, ap5_2, 3) == 0) ||
> +		(memcmp(mac->bssid, ap5_3, 3) == 0) ||
> +		(memcmp(mac->bssid, ap5_4, 3) == 0) ||
> +		(memcmp(mac->bssid, ap5_5, 3) == 0) ||
> +		(memcmp(mac->bssid, ap5_6, 3) == 0) ||
> +		vendor == PEER_ATH) {
> +		vendor = PEER_ATH;
> +		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD, ("=>ath find\n"));
> +	} else if ((memcmp(mac->bssid, ap4_4, 3) == 0) ||
> +		(memcmp(mac->bssid, ap4_5, 3) == 0) ||
> +		(memcmp(mac->bssid, ap4_1, 3) == 0) ||
> +		(memcmp(mac->bssid, ap4_2, 3) == 0) ||
> +		(memcmp(mac->bssid, ap4_3, 3) == 0) ||
> +		vendor == PEER_RAL) {
> +		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD, ("=>ral findn\n"));
> +		vendor = PEER_RAL;
> +	} else if (memcmp(mac->bssid, ap6_1, 3) == 0 ||
> +		vendor == PEER_CISCO) {
> +		vendor = PEER_CISCO;
> +		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD, ("=>cisco find\n"));
> +	} else if ((memcmp(mac->bssid, ap3_1, 3) == 0) ||
> +		(memcmp(mac->bssid, ap3_2, 3) == 0) ||
> +		(memcmp(mac->bssid, ap3_3, 3) == 0) ||
> +		vendor == PEER_BROAD) {
> +		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD, ("=>broad find\n"));
> +		vendor = PEER_BROAD;
> +	} else if (memcmp(mac->bssid, ap7_1, 3) == 0 ||
> +		vendor == PEER_MARV) {
> +		vendor = PEER_MARV;
> +		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD, ("=>marv find\n"));
> +	}
> +
> +	mac->vendor = vendor;
What for driver need that?

>  	mac->link_state = MAC80211_NOLINK;
>  	memset(mac->bssid, 0, 6);
We usually use ETH_ALEN

> +static int rtl_proc_get_mac_4(char *page, char **start,
> +		off_t offset, int count, int *eof, void *data)
> +{
> +	struct ieee80211_hw *hw = data;
> +	struct rtl_priv *rtlpriv = rtl_priv(hw);
> +	int len = 0;
> +	int i, n, page0;
> +	int max = 0xff;
> +	page0 = 0x400;
> +
> +	for (n = 0; n <= max; ) {
> +		len += snprintf(page + len, count - len, "\n%8.8x  ",
> +				n + page0);
> +		for (i = 0; i < 4 && n <= max; i++, n += 4)
> +			len += snprintf(page + len, count - len,
> +					"%8.8x    ",
> +					rtl_read_dword(rtlpriv, (page0 | n)));
> +	}
> +
> +	len += snprintf(page + len, count - len, "\n");
> +	*eof = 1;
> +	return len;
> +
> +}
> +
> +static int rtl_proc_get_mac_5(char *page, char **start,
> +		off_t offset, int count, int *eof, void *data)
> +{
> +	struct ieee80211_hw *hw = data;
> +	struct rtl_priv *rtlpriv = rtl_priv(hw);
> +	int len = 0;
> +	int i, n, page0;
> +	int max = 0xff;
> +	page0 = 0x500;
> +
> +	for (n = 0; n <= max; ) {
> +		len += snprintf(page + len, count - len, "\n%8.8x  ",
> +				n + page0);
> +		for (i = 0; i < 4 && n <= max; i++, n += 4)
> +			len += snprintf(page + len, count - len,
> +					"%8.8x    ",
> +					rtl_read_dword(rtlpriv, (page0 | n)));
> +	}
> +
> +	len += snprintf(page + len, count - len, "\n");
> +	*eof = 1;
> +	return len;
> +
> +}
All this functions rtl_proc_get_mac_X are the same, create
one procedure with page0 argument.

> +static int rtl_proc_get_cam_register_1(char *page, char **start,
> +		off_t offset, int count, int *eof, void *data)
> +{
[snip]
> +static int rtl_proc_get_cam_register_2(char *page, char **start,
> +		off_t offset, int count, int *eof, void *data)
> +{
Also for rtl_proc_get_cam_register_X.

> +void rtl_proc_add_one(struct ieee80211_hw *hw)
> +{
> +	struct rtl_priv *rtlpriv = rtl_priv(hw);
> +	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
> +	struct proc_dir_entry *entry;
> +
> +	snprintf(rtlpriv->dbg.proc_name, 18, "%x-%x-%x-%x-%x-%x",
> +		rtlefuse->dev_addr[0], rtlefuse->dev_addr[1],
> +		rtlefuse->dev_addr[2], rtlefuse->dev_addr[3],
> +		rtlefuse->dev_addr[4], rtlefuse->dev_addr[5]);
> +
> +	rtlpriv->dbg.proc_dir = create_proc_entry(rtlpriv->dbg.proc_name,
> +		S_IFDIR | S_IRUGO | S_IXUGO, proc_topdir);
> +	if (!rtlpriv->dbg.proc_dir) {
> +		RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG, ("Unable to init "
> +			"/proc/net/%s/%s\n", rtlpriv->cfg->name,
> +			rtlpriv->dbg.proc_name));
> +		return;
> +	}
> +
> +	entry = create_proc_read_entry("mac-0", S_IFREG | S_IRUGO,
> +				   rtlpriv->dbg.proc_dir,
> +				   rtl_proc_get_mac_0, hw);
Hmm, I think you need to convert to sysfs or debugfs.
 
> +			u8 *ptr = (u8 *)_hexdata;			       \
>  			printk(KERN_DEBUG "%s: ", KBUILD_MODNAME);	\
> -			printk("In process \"%s\" (pid %i):", current->comm,\
> +			printk(KERN_DEBUG "In process \"%s\" (pid %i):",\
> +					current->comm, \
>  					current->pid); \
>  			printk(_titlestring);		\
>  			for (__i = 0; __i < (int)_hexdatalen; __i++) {	\
> -				printk("%02X%s", ptr[__i], (((__i + 1) % 4)\
> -							== 0) ? "  " : " ");\
> +				printk(KERN_DEBUG "%02X%s", ptr[__i],	\
> +				(((__i + 1) % 4) == 0) ? "  " : " ");	\
>  				if (((__i + 1) % 16) == 0)		\
> -					printk("\n");			\
> -			}				\
> +					printk(KERN_DEBUG "\n");	\
> +			}						\
>  			printk(KERN_DEBUG "\n");			\
There must be generic functions for printing binary data in hex.

>  	memcpy((void *)&rtlefuse->efuse_map[EFUSE_MODIFY_MAP][0],
> -	       (void *)&rtlefuse->efuse_map[EFUSE_INIT_MAP][0],
> -	       rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE]);
> +			(void *)&rtlefuse->efuse_map[EFUSE_INIT_MAP][0],
> +			rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE]);
(void *) casts must be unneeded or we override const data.

> -	rate->idx = (rix > 0x2) ? rix : 0x2;
> +	rate->idx = rix >= 0x00 ? rix : 0x00;
Does not make sense, because rix is unsigned.

> +#define	N_BYTE_ALIGMENT(__value, __aligment) ((__aligment == 1) ? \
> +	(__value) : (((__value + __aligment - 1) / __aligment) * __aligment))
I think this do the same as ALIGN from kernel.h .

>  #define CP_MACADDR(des, src)	\
> -	((des)[0] = (src)[0], (des)[1] = (src)[1],\
> -	(des)[2] = (src)[2], (des)[3] = (src)[3],\
> -	(des)[4] = (src)[4], (des)[5] = (src)[5])
> +	(			\
> +		((des)[0] = (src)[0], (des)[1] = (src)[1],\
> +		(des)[2] = (src)[2], (des)[3] = (src)[3],\
> +		(des)[4] = (src)[4], (des)[5] = (src)[5]) \
> +	)
Use memcpy(dst, src, ETH_ALEN)

