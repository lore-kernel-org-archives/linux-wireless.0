Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5DA052B1CC
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 13:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788875271; cv=none; b=PQU34jPD46z3FM68Yd+bxn+QNkQUtWekN9NAtrdvlcR7hV3kpV70ehOKTwYRBG550LnGU8wlifJHIRzjeM0c/wiAnGWUlgKbtBNLCD5NYCcIFx13E+xvaO40/PJtw6x8p3gM2F0d7sFoUUmSpINfghbSQFgAqSO18t7Dl40o61E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788875271; c=relaxed/simple;
	bh=umxaBqsDA3JnWARdBFTAGtf9h+4Tv4St6sBufuGQWeo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oYDm9P7QR8+8xHzJm12z+Nyed3DUNWxu4jEtMBFKhGbmIqwJ0CEATgyYNqsonj/hAfqJF70j4mPnVj8X4Z3sPLMPRTsk8hfyCNhPS3bAkyxLlvKPB6AWPmzwC32/uczeSQ/q+u2Aq7mtxgdapDaRbLgWXlQhHdtcbzGUw6BgWYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jIaHhhMS; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jIaHhhMS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788875264; x=1820411264;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=umxaBqsDA3JnWARdBFTAGtf9h+4Tv4St6sBufuGQWeo=;
  b=jIaHhhMSycHaT3jDk4kP17Wf1sy5YurJHefk2oLqCWlm0XffjvOUuzB6
   Yp5tDyiaVIyFuQHicCtGKD8KtpmD0h1CB4dHM0EYPzI8Sxl9Pb89D1OOW
   86EITdHMATlMB/8iLmJmosKYAv+juyZhNB8PrPqY8a8FYnE0E/bwMrX41
   2vDz3Vr1zDRRvTcQkKZVR3wmpFIuJXYS3+YGkLaEr/MsdtSDezpYtM1vI
   J76TijpKm5kNe3ukbF3rsoIj2tC3k2oC4Ea31i7IadWbKGLr0dA3NPI6R
   Xi1Zu3Y8Iq287Q4nnlpsb3HcD8IVqo4MqoGZeOhjmFIx5H1Rcylc02tX4
   A==;
X-CSE-ConnectionGUID: gc+G2SItTmmKkZHGLbY0yw==
X-CSE-MsgGUID: k2Olq6yFRwm/tzKJOASNZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11899"; a="89480919"
X-IronPort-AV: E=Sophos;i="6.25,269,1779174000"; 
   d="scan'208";a="89480919"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2026 06:47:39 -0700
X-CSE-ConnectionGUID: +rz1lQxKSkuGWkqWsW1o9w==
X-CSE-MsgGUID: QjcnlhOBSceTotNGF2XZ2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,269,1779174000"; 
   d="scan'208";a="270983342"
Received: from lkp-server01.sh.intel.com (HELO dc5b8f51e05b) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 08 Sep 2026 06:47:37 -0700
Received: from kbuild by dc5b8f51e05b with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x3wAg-000000000AB-3ITx;
	Tue, 08 Sep 2026 13:47:34 +0000
Date: Tue, 8 Sep 2026 21:46:54 +0800
From: kernel test robot <lkp@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	syzbot+b4aa2b672b18f1d4dc5f@syzkaller.appspotmail.com
Subject: Re: [PATCH wireless] wifi: mac80211_hwsim: don't hand frames to
 mac80211 while stopping
Message-ID: <202609082134.nNCnnJQL-lkp@intel.com>
References: <20260904170140.5f69a10d606b.I4a7921d00643f69e439c7a3b221d104f66a3dcdc@changeid>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904170140.5f69a10d606b.I4a7921d00643f69e439c7a3b221d104f66a3dcdc@changeid>

Hi Johannes,

kernel test robot noticed the following build warnings:

[auto build test WARNING on wireless-next/main]
[also build test WARNING on wireless/main linus/master v7.3-rc2 next-20260907]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Johannes-Berg/wifi-mac80211_hwsim-don-t-hand-frames-to-mac80211-while-stopping/20260904-170135
base:   https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git main
patch link:    https://lore.kernel.org/r/20260904170140.5f69a10d606b.I4a7921d00643f69e439c7a3b221d104f66a3dcdc%40changeid
patch subject: [PATCH wireless] wifi: mac80211_hwsim: don't hand frames to mac80211 while stopping
config: sparc64-allmodconfig (https://download.01.org/0day-ci/archive/20260908/202609082134.nNCnnJQL-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260908/202609082134.nNCnnJQL-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609082134.nNCnnJQL-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/net/wireless/virtual/mac80211_hwsim_main.c:6517:6: warning: variable 'data2' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
    6517 |         if (skb == NULL)
         |             ^~~~~~~~~~~
   drivers/net/wireless/virtual/mac80211_hwsim_main.c:6607:16: note: uninitialized use occurs here
    6607 |         mutex_unlock(&data2->mutex);
         |                       ^~~~~
   drivers/net/wireless/virtual/mac80211_hwsim_main.c:6517:2: note: remove the 'if' if its condition is always false
    6517 |         if (skb == NULL)
         |         ^~~~~~~~~~~~~~~~
    6518 |                 goto err;
         |                 ~~~~~~~~
   drivers/net/wireless/virtual/mac80211_hwsim_main.c:6511:6: warning: variable 'data2' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
    6511 |         if (frame_data_len < sizeof(struct ieee80211_hdr_3addr) ||
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    6512 |             frame_data_len > IEEE80211_MAX_DATA_LEN)
         |             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/wireless/virtual/mac80211_hwsim_main.c:6607:16: note: uninitialized use occurs here
    6607 |         mutex_unlock(&data2->mutex);
         |                       ^~~~~
   drivers/net/wireless/virtual/mac80211_hwsim_main.c:6511:2: note: remove the 'if' if its condition is always false
    6511 |         if (frame_data_len < sizeof(struct ieee80211_hdr_3addr) ||
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    6512 |             frame_data_len > IEEE80211_MAX_DATA_LEN)
         |             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    6513 |                 goto err;
         |                 ~~~~~~~~
>> drivers/net/wireless/virtual/mac80211_hwsim_main.c:6511:6: warning: variable 'data2' is used uninitialized whenever '||' condition is true [-Wsometimes-uninitialized]
    6511 |         if (frame_data_len < sizeof(struct ieee80211_hdr_3addr) ||
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/wireless/virtual/mac80211_hwsim_main.c:6607:16: note: uninitialized use occurs here
    6607 |         mutex_unlock(&data2->mutex);
         |                       ^~~~~
   drivers/net/wireless/virtual/mac80211_hwsim_main.c:6511:6: note: remove the '||' if its condition is always false
    6511 |         if (frame_data_len < sizeof(struct ieee80211_hdr_3addr) ||
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/wireless/virtual/mac80211_hwsim_main.c:6492:35: note: initialize the variable 'data2' to silence this warning
    6492 |         struct mac80211_hwsim_data *data2;
         |                                          ^
         |                                           = NULL
   3 warnings generated.


vim +6517 drivers/net/wireless/virtual/mac80211_hwsim_main.c

7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6488  
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6489  static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6490  					  struct genl_info *info)
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6491  {
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6492  	struct mac80211_hwsim_data *data2;
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6493  	struct ieee80211_rx_status rx_status;
05d610af3e71a78 drivers/net/wireless/mac80211_hwsim.c              Johannes Berg  2019-07-29  6494  	struct ieee80211_hdr *hdr;
9ddd12af103f60f drivers/net/wireless/mac80211_hwsim.c              Johannes Berg  2014-01-06  6495  	const u8 *dst;
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6496  	int frame_data_len;
9ddd12af103f60f drivers/net/wireless/mac80211_hwsim.c              Johannes Berg  2014-01-06  6497  	void *frame_data;
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6498  	struct sk_buff *skb = NULL;
626c30f9e773543 drivers/net/wireless/mac80211_hwsim.c              Weilun Du      2021-05-06  6499  	struct ieee80211_channel *channel = NULL;
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6500  
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6501  	if (!info->attrs[HWSIM_ATTR_ADDR_RECEIVER] ||
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6502  	    !info->attrs[HWSIM_ATTR_FRAME] ||
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6503  	    !info->attrs[HWSIM_ATTR_RX_RATE] ||
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6504  	    !info->attrs[HWSIM_ATTR_SIGNAL])
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6505  		goto out;
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6506  
9ddd12af103f60f drivers/net/wireless/mac80211_hwsim.c              Johannes Berg  2014-01-06  6507  	dst = (void *)nla_data(info->attrs[HWSIM_ATTR_ADDR_RECEIVER]);
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6508  	frame_data_len = nla_len(info->attrs[HWSIM_ATTR_FRAME]);
9ddd12af103f60f drivers/net/wireless/mac80211_hwsim.c              Johannes Berg  2014-01-06  6509  	frame_data = (void *)nla_data(info->attrs[HWSIM_ATTR_FRAME]);
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6510  
fba360a047d5eee drivers/net/wireless/virtual/mac80211_hwsim.c      Johannes Berg  2023-08-15 @6511  	if (frame_data_len < sizeof(struct ieee80211_hdr_3addr) ||
fba360a047d5eee drivers/net/wireless/virtual/mac80211_hwsim.c      Johannes Berg  2023-08-15  6512  	    frame_data_len > IEEE80211_MAX_DATA_LEN)
fba360a047d5eee drivers/net/wireless/virtual/mac80211_hwsim.c      Johannes Berg  2023-08-15  6513  		goto err;
fba360a047d5eee drivers/net/wireless/virtual/mac80211_hwsim.c      Johannes Berg  2023-08-15  6514  
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6515  	/* Allocate new skb here */
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6516  	skb = alloc_skb(frame_data_len, GFP_KERNEL);
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01 @6517  	if (skb == NULL)
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6518  		goto err;
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6519  
9ddd12af103f60f drivers/net/wireless/mac80211_hwsim.c              Johannes Berg  2014-01-06  6520  	/* Copy the data */
59ae1d127ac0ae4 drivers/net/wireless/mac80211_hwsim.c              Johannes Berg  2017-06-16  6521  	skb_put_data(skb, frame_data, frame_data_len);
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6522  
9ddd12af103f60f drivers/net/wireless/mac80211_hwsim.c              Johannes Berg  2014-01-06  6523  	data2 = get_hwsim_data_ref_from_addr(dst);
9ddd12af103f60f drivers/net/wireless/mac80211_hwsim.c              Johannes Berg  2014-01-06  6524  	if (!data2)
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6525  		goto out;
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6526  
626c30f9e773543 drivers/net/wireless/mac80211_hwsim.c              Weilun Du      2021-05-06  6527  	if (data2->use_chanctx) {
626c30f9e773543 drivers/net/wireless/mac80211_hwsim.c              Weilun Du      2021-05-06  6528  		if (data2->tmp_chan)
626c30f9e773543 drivers/net/wireless/mac80211_hwsim.c              Weilun Du      2021-05-06  6529  			channel = data2->tmp_chan;
626c30f9e773543 drivers/net/wireless/mac80211_hwsim.c              Weilun Du      2021-05-06  6530  	} else {
626c30f9e773543 drivers/net/wireless/mac80211_hwsim.c              Weilun Du      2021-05-06  6531  		channel = data2->channel;
626c30f9e773543 drivers/net/wireless/mac80211_hwsim.c              Weilun Du      2021-05-06  6532  	}
626c30f9e773543 drivers/net/wireless/mac80211_hwsim.c              Weilun Du      2021-05-06  6533  
5d44fe7c9808c56 drivers/net/wireless/mac80211_hwsim.c              Erel Geron     2020-03-05  6534  	if (!hwsim_virtio_enabled) {
5d44fe7c9808c56 drivers/net/wireless/mac80211_hwsim.c              Erel Geron     2020-03-05  6535  		if (hwsim_net_get_netgroup(genl_info_net(info)) !=
5d44fe7c9808c56 drivers/net/wireless/mac80211_hwsim.c              Erel Geron     2020-03-05  6536  		    data2->netgroup)
f21e4d8ed16bb9c drivers/net/wireless/mac80211_hwsim.c              Martin Willi   2016-05-14  6537  			goto out;
f21e4d8ed16bb9c drivers/net/wireless/mac80211_hwsim.c              Martin Willi   2016-05-14  6538  
f21e4d8ed16bb9c drivers/net/wireless/mac80211_hwsim.c              Martin Willi   2016-05-14  6539  		if (info->snd_portid != data2->wmediumd)
f21e4d8ed16bb9c drivers/net/wireless/mac80211_hwsim.c              Martin Willi   2016-05-14  6540  			goto out;
5d44fe7c9808c56 drivers/net/wireless/mac80211_hwsim.c              Erel Geron     2020-03-05  6541  	}
f21e4d8ed16bb9c drivers/net/wireless/mac80211_hwsim.c              Martin Willi   2016-05-14  6542  
a3658dbd0b37b9d drivers/net/wireless/virtual/mac80211_hwsim_main.c Johannes Berg  2026-09-04  6543  	/*
a3658dbd0b37b9d drivers/net/wireless/virtual/mac80211_hwsim_main.c Johannes Berg  2026-09-04  6544  	 * Serialise against mac80211_hwsim_stop() - mac80211 doesn't allow
a3658dbd0b37b9d drivers/net/wireless/virtual/mac80211_hwsim_main.c Johannes Berg  2026-09-04  6545  	 * frames reported while the HW is down, hence the ->started check
a3658dbd0b37b9d drivers/net/wireless/virtual/mac80211_hwsim_main.c Johannes Berg  2026-09-04  6546  	 * must be under mutex.
a3658dbd0b37b9d drivers/net/wireless/virtual/mac80211_hwsim_main.c Johannes Berg  2026-09-04  6547  	 */
a3658dbd0b37b9d drivers/net/wireless/virtual/mac80211_hwsim_main.c Johannes Berg  2026-09-04  6548  	mutex_lock(&data2->mutex);
a3658dbd0b37b9d drivers/net/wireless/virtual/mac80211_hwsim_main.c Johannes Berg  2026-09-04  6549  
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6550  	/* check if radio is configured properly */
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6551  
626c30f9e773543 drivers/net/wireless/mac80211_hwsim.c              Weilun Du      2021-05-06  6552  	if ((data2->idle && !data2->tmp_chan) || !data2->started)
a3658dbd0b37b9d drivers/net/wireless/virtual/mac80211_hwsim_main.c Johannes Berg  2026-09-04  6553  		goto out_unlock;
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6554  
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6555  	/* A frame is received from user space */
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6556  	memset(&rx_status, 0, sizeof(rx_status));
641cf2a5ba0345c drivers/net/wireless/mac80211_hwsim.c              Adam Welle     2015-12-01  6557  	if (info->attrs[HWSIM_ATTR_FREQ]) {
4f4b0f4eed556c9 drivers/net/wireless/virtual/mac80211_hwsim_main.c Benjamin Berg  2026-05-06  6558  		struct tx_iter_data iter_data = {
4f4b0f4eed556c9 drivers/net/wireless/virtual/mac80211_hwsim_main.c Benjamin Berg  2026-05-06  6559  			.hw = data2->hw,
4f4b0f4eed556c9 drivers/net/wireless/virtual/mac80211_hwsim_main.c Benjamin Berg  2026-05-06  6560  			.rx_status = &rx_status,
4f4b0f4eed556c9 drivers/net/wireless/virtual/mac80211_hwsim_main.c Benjamin Berg  2026-05-06  6561  		};
c204d9df02020e2 drivers/net/wireless/mac80211_hwsim.c              Johannes Berg  2022-07-20  6562  
641cf2a5ba0345c drivers/net/wireless/mac80211_hwsim.c              Adam Welle     2015-12-01  6563  		/* throw away off-channel packets, but allow both the temporary
c204d9df02020e2 drivers/net/wireless/mac80211_hwsim.c              Johannes Berg  2022-07-20  6564  		 * ("hw" scan/remain-on-channel), regular channels and links,
c204d9df02020e2 drivers/net/wireless/mac80211_hwsim.c              Johannes Berg  2022-07-20  6565  		 * since the internal datapath also allows this
4f86ed8f87c07b3 drivers/net/wireless/mac80211_hwsim.c              Ben Greear     2014-10-27  6566  		 */
641cf2a5ba0345c drivers/net/wireless/mac80211_hwsim.c              Adam Welle     2015-12-01  6567  		rx_status.freq = nla_get_u32(info->attrs[HWSIM_ATTR_FREQ]);
641cf2a5ba0345c drivers/net/wireless/mac80211_hwsim.c              Adam Welle     2015-12-01  6568  
c204d9df02020e2 drivers/net/wireless/mac80211_hwsim.c              Johannes Berg  2022-07-20  6569  		iter_data.channel = ieee80211_get_channel(data2->hw->wiphy,
c204d9df02020e2 drivers/net/wireless/mac80211_hwsim.c              Johannes Berg  2022-07-20  6570  							  rx_status.freq);
c204d9df02020e2 drivers/net/wireless/mac80211_hwsim.c              Johannes Berg  2022-07-20  6571  		if (!iter_data.channel)
a3658dbd0b37b9d drivers/net/wireless/virtual/mac80211_hwsim_main.c Johannes Berg  2026-09-04  6572  			goto out_unlock;
c087f9fcd0fb534 drivers/net/wireless/mac80211_hwsim.c              Johannes Berg  2022-09-02  6573  		rx_status.band = iter_data.channel->band;
c204d9df02020e2 drivers/net/wireless/mac80211_hwsim.c              Johannes Berg  2022-07-20  6574  
c204d9df02020e2 drivers/net/wireless/mac80211_hwsim.c              Johannes Berg  2022-07-20  6575  		if (!hwsim_chans_compat(iter_data.channel, channel)) {
c204d9df02020e2 drivers/net/wireless/mac80211_hwsim.c              Johannes Berg  2022-07-20  6576  			ieee80211_iterate_active_interfaces_atomic(
c204d9df02020e2 drivers/net/wireless/mac80211_hwsim.c              Johannes Berg  2022-07-20  6577  				data2->hw, IEEE80211_IFACE_ITER_NORMAL,
c204d9df02020e2 drivers/net/wireless/mac80211_hwsim.c              Johannes Berg  2022-07-20  6578  				mac80211_hwsim_tx_iter, &iter_data);
a3658dbd0b37b9d drivers/net/wireless/virtual/mac80211_hwsim_main.c Johannes Berg  2026-09-04  6579  			if (!iter_data.receive)
a3658dbd0b37b9d drivers/net/wireless/virtual/mac80211_hwsim_main.c Johannes Berg  2026-09-04  6580  				goto out_unlock;
641cf2a5ba0345c drivers/net/wireless/mac80211_hwsim.c              Adam Welle     2015-12-01  6581  		}
c087f9fcd0fb534 drivers/net/wireless/mac80211_hwsim.c              Johannes Berg  2022-09-02  6582  	} else if (!channel) {
a3658dbd0b37b9d drivers/net/wireless/virtual/mac80211_hwsim_main.c Johannes Berg  2026-09-04  6583  		goto out_unlock;
641cf2a5ba0345c drivers/net/wireless/mac80211_hwsim.c              Adam Welle     2015-12-01  6584  	} else {
626c30f9e773543 drivers/net/wireless/mac80211_hwsim.c              Weilun Du      2021-05-06  6585  		rx_status.freq = channel->center_freq;
c087f9fcd0fb534 drivers/net/wireless/mac80211_hwsim.c              Johannes Berg  2022-09-02  6586  		rx_status.band = channel->band;
641cf2a5ba0345c drivers/net/wireless/mac80211_hwsim.c              Adam Welle     2015-12-01  6587  	}
641cf2a5ba0345c drivers/net/wireless/mac80211_hwsim.c              Adam Welle     2015-12-01  6588  
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6589  	rx_status.rate_idx = nla_get_u32(info->attrs[HWSIM_ATTR_RX_RATE]);
1833b6f46d7e283 drivers/net/wireless/mac80211_hwsim.c              Johannes Berg  2022-10-05  6590  	if (rx_status.rate_idx >= data2->hw->wiphy->bands[rx_status.band]->n_bitrates)
a3658dbd0b37b9d drivers/net/wireless/virtual/mac80211_hwsim_main.c Johannes Berg  2026-09-04  6591  		goto out_unlock;
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6592  	rx_status.signal = nla_get_u32(info->attrs[HWSIM_ATTR_SIGNAL]);
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6593  
05d610af3e71a78 drivers/net/wireless/mac80211_hwsim.c              Johannes Berg  2019-07-29  6594  	hdr = (void *)skb->data;
05d610af3e71a78 drivers/net/wireless/mac80211_hwsim.c              Johannes Berg  2019-07-29  6595  
05d610af3e71a78 drivers/net/wireless/mac80211_hwsim.c              Johannes Berg  2019-07-29  6596  	if (ieee80211_is_beacon(hdr->frame_control) ||
05d610af3e71a78 drivers/net/wireless/mac80211_hwsim.c              Johannes Berg  2019-07-29  6597  	    ieee80211_is_probe_resp(hdr->frame_control))
05d610af3e71a78 drivers/net/wireless/mac80211_hwsim.c              Johannes Berg  2019-07-29  6598  		rx_status.boottime_ns = ktime_get_boottime_ns();
05d610af3e71a78 drivers/net/wireless/mac80211_hwsim.c              Johannes Berg  2019-07-29  6599  
b1622adaa55541f drivers/net/wireless/mac80211_hwsim.c              Johannes Berg  2022-09-02  6600  	mac80211_hwsim_rx(data2, &rx_status, skb);
a3658dbd0b37b9d drivers/net/wireless/virtual/mac80211_hwsim_main.c Johannes Berg  2026-09-04  6601  	mutex_unlock(&data2->mutex);
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6602  
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6603  	return 0;
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6604  err:
62b093b375e3c10 drivers/net/wireless/mac80211_hwsim.c              Lubomir Rintel 2017-09-18  6605  	pr_debug("mac80211_hwsim: error occurred in %s\n", __func__);
a3658dbd0b37b9d drivers/net/wireless/virtual/mac80211_hwsim_main.c Johannes Berg  2026-09-04  6606  out_unlock:
a3658dbd0b37b9d drivers/net/wireless/virtual/mac80211_hwsim_main.c Johannes Berg  2026-09-04  6607  	mutex_unlock(&data2->mutex);
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6608  out:
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6609  	dev_kfree_skb(skb);
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6610  	return -EINVAL;
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6611  }
7882513bacb176a drivers/net/wireless/mac80211_hwsim.c              Javier Lopez   2011-06-01  6612  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
