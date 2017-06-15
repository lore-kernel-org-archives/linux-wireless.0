Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:10684 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751644AbdFOWYr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 18:24:47 -0400
Date: Fri, 16 Jun 2017 06:23:49 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: kbuild-all@01.org, linux-wireless@vger.kernel.org
Subject: [mac80211-next:skb-put-zero 5/5] drivers/net/ppp/ppp_async.c:805:3:
 error: invalid use of void expression
Message-ID: <201706160642.mIYkjXhV%fengguang.wu@intel.com> (sfid-20170616_002451_329906_1DA61B56)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/9DWx/yDrRhgMJTb"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git skb-put-zero
head:   f18c9b85b5d68bb029dc1f8c82bae33632d6f485
commit: f18c9b85b5d68bb029dc1f8c82bae33632d6f485 [5/5] networking: make skb_push & __skb_push return void*
config: m68k-sun3_defconfig (attached as .config)
compiler: m68k-linux-gcc (GCC) 4.9.0
reproduce:
        wget https://raw.githubusercontent.com/01org/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        git checkout f18c9b85b5d68bb029dc1f8c82bae33632d6f485
        # save the attached .config to linux build tree
        make.cross ARCH=m68k 

All error/warnings (new ones prefixed by >>):

   drivers/net/ppp/ppp_async.c: In function 'process_input_packet':
>> drivers/net/ppp/ppp_async.c:805:19: warning: dereferencing 'void *' pointer
      skb_push(skb, 1)[0] = 0;
                      ^
>> drivers/net/ppp/ppp_async.c:805:3: error: invalid use of void expression
      skb_push(skb, 1)[0] = 0;
      ^
--
   drivers/net/ppp/ppp_synctty.c: In function 'ppp_sync_input':
>> drivers/net/ppp/ppp_synctty.c:714:19: warning: dereferencing 'void *' pointer
      skb_push(skb, 1)[0] = 0;
                      ^
>> drivers/net/ppp/ppp_synctty.c:714:3: error: invalid use of void expression
      skb_push(skb, 1)[0] = 0;
      ^
--
   drivers/net/ppp/pptp.c: In function 'pptp_rcv_core':
>> drivers/net/ppp/pptp.c:331:20: warning: dereferencing 'void *' pointer
       skb_push(skb, 1)[0] = 0;
                       ^
>> drivers/net/ppp/pptp.c:331:4: error: invalid use of void expression
       skb_push(skb, 1)[0] = 0;
       ^

vim +805 drivers/net/ppp/ppp_async.c

^1da177e drivers/net/ppp_async.c Linus Torvalds 2005-04-16  789  		fcs = PPP_FCS(fcs, *p++);
^1da177e drivers/net/ppp_async.c Linus Torvalds 2005-04-16  790  	if (fcs != PPP_GOODFCS)
^1da177e drivers/net/ppp_async.c Linus Torvalds 2005-04-16  791  		goto err;	/* bad FCS */
^1da177e drivers/net/ppp_async.c Linus Torvalds 2005-04-16  792  	skb_trim(skb, skb->len - 2);
^1da177e drivers/net/ppp_async.c Linus Torvalds 2005-04-16  793  
^1da177e drivers/net/ppp_async.c Linus Torvalds 2005-04-16  794  	/* check for address/control and protocol compression */
^1da177e drivers/net/ppp_async.c Linus Torvalds 2005-04-16  795  	p = skb->data;
7c5050e3 drivers/net/ppp_async.c Paul Mackerras 2007-04-19  796  	if (p[0] == PPP_ALLSTATIONS) {
^1da177e drivers/net/ppp_async.c Linus Torvalds 2005-04-16  797  		/* chop off address/control */
7c5050e3 drivers/net/ppp_async.c Paul Mackerras 2007-04-19  798  		if (p[1] != PPP_UI || skb->len < 3)
^1da177e drivers/net/ppp_async.c Linus Torvalds 2005-04-16  799  			goto err;
^1da177e drivers/net/ppp_async.c Linus Torvalds 2005-04-16  800  		p = skb_pull(skb, 2);
^1da177e drivers/net/ppp_async.c Linus Torvalds 2005-04-16  801  	}
^1da177e drivers/net/ppp_async.c Linus Torvalds 2005-04-16  802  	proto = p[0];
^1da177e drivers/net/ppp_async.c Linus Torvalds 2005-04-16  803  	if (proto & 1) {
^1da177e drivers/net/ppp_async.c Linus Torvalds 2005-04-16  804  		/* protocol is compressed */
^1da177e drivers/net/ppp_async.c Linus Torvalds 2005-04-16 @805  		skb_push(skb, 1)[0] = 0;
^1da177e drivers/net/ppp_async.c Linus Torvalds 2005-04-16  806  	} else {
^1da177e drivers/net/ppp_async.c Linus Torvalds 2005-04-16  807  		if (skb->len < 2)
^1da177e drivers/net/ppp_async.c Linus Torvalds 2005-04-16  808  			goto err;
^1da177e drivers/net/ppp_async.c Linus Torvalds 2005-04-16  809  		proto = (proto << 8) + p[1];
^1da177e drivers/net/ppp_async.c Linus Torvalds 2005-04-16  810  		if (proto == PPP_LCP)
^1da177e drivers/net/ppp_async.c Linus Torvalds 2005-04-16  811  			async_lcp_peek(ap, p, skb->len, 1);
^1da177e drivers/net/ppp_async.c Linus Torvalds 2005-04-16  812  	}
^1da177e drivers/net/ppp_async.c Linus Torvalds 2005-04-16  813  

:::::: The code at line 805 was first introduced by commit
:::::: 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 Linux-2.6.12-rc2

:::::: TO: Linus Torvalds <torvalds@ppc970.osdl.org>
:::::: CC: Linus Torvalds <torvalds@ppc970.osdl.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--/9DWx/yDrRhgMJTb
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--/9DWx/yDrRhgMJTb--
