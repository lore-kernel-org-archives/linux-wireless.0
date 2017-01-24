Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:60344 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750914AbdAXXmE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jan 2017 18:42:04 -0500
Date: Wed, 25 Jan 2017 07:41:20 +0800
From: kbuild test robot <lkp@intel.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: kbuild-all@01.org, Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH 2/6] brcmfmac: add struct brcmf_pub parameter to the
 __brcmf_err
Message-ID: <201701250743.TLplbZ9e%fengguang.wu@intel.com> (sfid-20170125_004210_073771_26D2492A)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="k+w/mQv8wyuph6w0"
In-Reply-To: <20170124150612.25138-2-zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Rafał,

[auto build test ERROR on wireless-drivers-next/master]
[also build test ERROR on v4.10-rc5 next-20170124]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Rafa-Mi-ecki/brcmfmac-switch-to-C-function-__brcmf_err-for-printing-errors/20170125-033714
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master
config: i386-randconfig-h1-01250553 (attached as .config)
compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All error/warnings (new ones prefixed by >>):

   In file included from drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c:21:0:
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h:81:24: warning: 'struct device' declared inside parameter list will not be visible outside of this definition or declaration
     int (*preinit)(struct device *dev);
                           ^~~~~~
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h:82:22: warning: 'struct device' declared inside parameter list will not be visible outside of this definition or declaration
     void (*stop)(struct device *dev);
                         ^~~~~~
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h:83:23: warning: 'struct device' declared inside parameter list will not be visible outside of this definition or declaration
     int (*txdata)(struct device *dev, struct sk_buff *skb);
                          ^~~~~~
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h:84:22: warning: 'struct device' declared inside parameter list will not be visible outside of this definition or declaration
     int (*txctl)(struct device *dev, unsigned char *msg, uint len);
                         ^~~~~~
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h:85:22: warning: 'struct device' declared inside parameter list will not be visible outside of this definition or declaration
     int (*rxctl)(struct device *dev, unsigned char *msg, uint len);
                         ^~~~~~
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h:86:33: warning: 'struct device' declared inside parameter list will not be visible outside of this definition or declaration
     struct pktq * (*gettxq)(struct device *dev);
                                    ^~~~~~
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h:87:29: warning: 'struct device' declared inside parameter list will not be visible outside of this definition or declaration
     void (*wowl_config)(struct device *dev, bool enabled);
                                ^~~~~~
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h:88:31: warning: 'struct device' declared inside parameter list will not be visible outside of this definition or declaration
     size_t (*get_ramsize)(struct device *dev);
                                  ^~~~~~
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h:89:28: warning: 'struct device' declared inside parameter list will not be visible outside of this definition or declaration
     int (*get_memdump)(struct device *dev, void *data, size_t len);
                               ^~~~~~
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h: In function 'brcmf_bus_preinit':
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h:159:27: error: passing argument 1 of 'bus->ops->preinit' from incompatible pointer type [-Werror=incompatible-pointer-types]
     return bus->ops->preinit(bus->dev);
                              ^~~
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h:159:27: note: expected 'struct device *' but argument is of type 'struct device *'
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h: In function 'brcmf_bus_stop':
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h:164:17: error: passing argument 1 of 'bus->ops->stop' from incompatible pointer type [-Werror=incompatible-pointer-types]
     bus->ops->stop(bus->dev);
                    ^~~
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h:164:17: note: expected 'struct device *' but argument is of type 'struct device *'
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h: In function 'brcmf_bus_txdata':
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h:169:26: error: passing argument 1 of 'bus->ops->txdata' from incompatible pointer type [-Werror=incompatible-pointer-types]
     return bus->ops->txdata(bus->dev, skb);
                             ^~~
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h:169:26: note: expected 'struct device *' but argument is of type 'struct device *'
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h: In function 'brcmf_bus_txctl':
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h:175:25: error: passing argument 1 of 'bus->ops->txctl' from incompatible pointer type [-Werror=incompatible-pointer-types]
     return bus->ops->txctl(bus->dev, msg, len);
                            ^~~
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h:175:25: note: expected 'struct device *' but argument is of type 'struct device *'
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h: In function 'brcmf_bus_rxctl':
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h:181:25: error: passing argument 1 of 'bus->ops->rxctl' from incompatible pointer type [-Werror=incompatible-pointer-types]
     return bus->ops->rxctl(bus->dev, msg, len);
                            ^~~
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h:181:25: note: expected 'struct device *' but argument is of type 'struct device *'
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h: In function 'brcmf_bus_gettxq':
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h:190:26: error: passing argument 1 of 'bus->ops->gettxq' from incompatible pointer type [-Werror=incompatible-pointer-types]
     return bus->ops->gettxq(bus->dev);
                             ^~~
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h:190:26: note: expected 'struct device *' but argument is of type 'struct device *'
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h: In function 'brcmf_bus_wowl_config':
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h:197:25: error: passing argument 1 of 'bus->ops->wowl_config' from incompatible pointer type [-Werror=incompatible-pointer-types]
      bus->ops->wowl_config(bus->dev, enabled);
                            ^~~
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h:197:25: note: expected 'struct device *' but argument is of type 'struct device *'
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h: In function 'brcmf_bus_get_ramsize':
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h:205:31: error: passing argument 1 of 'bus->ops->get_ramsize' from incompatible pointer type [-Werror=incompatible-pointer-types]
     return bus->ops->get_ramsize(bus->dev);
                                  ^~~
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h:205:31: note: expected 'struct device *' but argument is of type 'struct device *'
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h: In function 'brcmf_bus_get_memdump':
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h:214:31: error: passing argument 1 of 'bus->ops->get_memdump' from incompatible pointer type [-Werror=incompatible-pointer-types]
     return bus->ops->get_memdump(bus->dev, data, len);
                                  ^~~
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h:214:31: note: expected 'struct device *' but argument is of type 'struct device *'
   cc1: some warnings being treated as errors

vim +159 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h

d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05   75   * This structure provides an abstract interface towards the
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05   76   * bus specific driver. For control messages to common driver
e2432b67 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2013-04-03   77   * will assure there is only one active transaction. Unless
e2432b67 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2013-04-03   78   * indicated otherwise these callbacks are mandatory.
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05   79   */
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05   80  struct brcmf_bus_ops {
cf458287 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2013-11-29  @81  	int (*preinit)(struct device *dev);
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05   82  	void (*stop)(struct device *dev);
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05   83  	int (*txdata)(struct device *dev, struct sk_buff *skb);
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05   84  	int (*txctl)(struct device *dev, unsigned char *msg, uint len);
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05   85  	int (*rxctl)(struct device *dev, unsigned char *msg, uint len);
e2432b67 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2013-04-03   86  	struct pktq * (*gettxq)(struct device *dev);
4eb3af7c drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Hante Meuleman   2014-09-30   87  	void (*wowl_config)(struct device *dev, bool enabled);
ff4445a8 drivers/net/wireless/brcm80211/brcmfmac/bus.h          Arend van Spriel 2015-10-08  @88  	size_t (*get_ramsize)(struct device *dev);
ff4445a8 drivers/net/wireless/brcm80211/brcmfmac/bus.h          Arend van Spriel 2015-10-08  @89  	int (*get_memdump)(struct device *dev, void *data, size_t len);
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05   90  };
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05   91  
9a1bb602 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Hante Meuleman   2014-07-30   92  
9a1bb602 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Hante Meuleman   2014-07-30   93  /**
9a1bb602 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Hante Meuleman   2014-07-30   94   * struct brcmf_bus_msgbuf - bus ringbuf if in case of msgbuf.
9a1bb602 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Hante Meuleman   2014-07-30   95   *
9a1bb602 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Hante Meuleman   2014-07-30   96   * @commonrings: commonrings which are always there.
9a1bb602 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Hante Meuleman   2014-07-30   97   * @flowrings: commonrings which are dynamically created and destroyed for data.
9a1bb602 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Hante Meuleman   2014-07-30   98   * @rx_dataoffset: if set then all rx data has this this offset.
9a1bb602 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Hante Meuleman   2014-07-30   99   * @max_rxbufpost: maximum number of buffers to post for rx.
be4b092c drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h Franky Lin       2016-11-23  100   * @max_flowrings: maximum number of tx flow rings supported.
be4b092c drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h Franky Lin       2016-11-23  101   * @max_submissionrings: maximum number of submission rings(h2d) supported.
be4b092c drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h Franky Lin       2016-11-23  102   * @max_completionrings: maximum number of completion rings(d2h) supported.
9a1bb602 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Hante Meuleman   2014-07-30  103   */
9a1bb602 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Hante Meuleman   2014-07-30  104  struct brcmf_bus_msgbuf {
9a1bb602 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Hante Meuleman   2014-07-30  105  	struct brcmf_commonring *commonrings[BRCMF_NROF_COMMON_MSGRINGS];
9a1bb602 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Hante Meuleman   2014-07-30  106  	struct brcmf_commonring **flowrings;
9a1bb602 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Hante Meuleman   2014-07-30  107  	u32 rx_dataoffset;
9a1bb602 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Hante Meuleman   2014-07-30  108  	u32 max_rxbufpost;
be4b092c drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h Franky Lin       2016-11-23  109  	u16 max_flowrings;
be4b092c drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h Franky Lin       2016-11-23  110  	u16 max_submissionrings;
be4b092c drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h Franky Lin       2016-11-23  111  	u16 max_completionrings;
9a1bb602 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Hante Meuleman   2014-07-30  112  };
9a1bb602 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Hante Meuleman   2014-07-30  113  
9a1bb602 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Hante Meuleman   2014-07-30  114  
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05  115  /**
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05  116   * struct brcmf_bus - interface structure between common and bus layer
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05  117   *
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05  118   * @bus_priv: pointer to private bus device.
943258b6 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Hante Meuleman   2013-12-12  119   * @proto_type: protocol type, bcdc or msgbuf
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05  120   * @dev: device pointer of bus device.
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05  121   * @drvr: public driver information.
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05  122   * @state: operational state of the bus interface.
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05  123   * @maxctl: maximum size for rxctl request message.
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05  124   * @tx_realloc: number of tx packets realloced for headroom.
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05  125   * @dstats: dongle-based statistical data.
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05  126   * @dcmd_list: bus/device specific dongle initialization commands.
75d907d3 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2013-02-06  127   * @chip: device identifier of the dongle chip.
4eb3af7c drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Hante Meuleman   2014-09-30  128   * @wowl_supported: is wowl supported by bus driver.
75d907d3 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2013-02-06  129   * @chiprev: revision of the dongle chip.
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05  130   */
a8a363ac drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Franky Lin       2011-12-16  131  struct brcmf_bus {
0a332e46 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-02-09  132  	union {
0a332e46 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-02-09  133  		struct brcmf_sdio_dev *sdio;
71bb244b drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-02-09  134  		struct brcmf_usbdev *usb;
9e37f045 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Hante Meuleman   2014-07-30  135  		struct brcmf_pciedev *pcie;
0a332e46 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-02-09  136  	} bus_priv;
943258b6 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Hante Meuleman   2013-12-12  137  	enum brcmf_bus_protocol_type proto_type;
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05  138  	struct device *dev;
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05  139  	struct brcmf_pub *drvr;
a8a363ac drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Franky Lin       2011-12-16  140  	enum brcmf_bus_state state;
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05  141  	uint maxctl;
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05  142  	unsigned long tx_realloc;
75d907d3 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2013-02-06  143  	u32 chip;
75d907d3 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2013-02-06  144  	u32 chiprev;
9cd18359 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Hante Meuleman   2014-05-12  145  	bool always_use_fws_queue;
4eb3af7c drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Hante Meuleman   2014-09-30  146  	bool wowl_supported;
a8a363ac drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Franky Lin       2011-12-16  147  
6866a64a drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h Julia Lawall     2015-11-14  148  	const struct brcmf_bus_ops *ops;
9a1bb602 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Hante Meuleman   2014-07-30  149  	struct brcmf_bus_msgbuf *msgbuf;
a8a363ac drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Franky Lin       2011-12-16  150  };
a8a363ac drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Franky Lin       2011-12-16  151  
a8a363ac drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Franky Lin       2011-12-16  152  /*
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05  153   * callback wrappers
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05  154   */
cf458287 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2013-11-29  155  static inline int brcmf_bus_preinit(struct brcmf_bus *bus)
cf458287 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2013-11-29  156  {
cf458287 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2013-11-29  157  	if (!bus->ops->preinit)
cf458287 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2013-11-29  158  		return 0;
cf458287 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2013-11-29 @159  	return bus->ops->preinit(bus->dev);
cf458287 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2013-11-29  160  }
cf458287 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2013-11-29  161  
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05  162  static inline void brcmf_bus_stop(struct brcmf_bus *bus)
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05  163  {
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05 @164  	bus->ops->stop(bus->dev);
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05  165  }
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05  166  
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05  167  static inline int brcmf_bus_txdata(struct brcmf_bus *bus, struct sk_buff *skb)
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05  168  {
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05 @169  	return bus->ops->txdata(bus->dev, skb);
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05  170  }
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05  171  
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05  172  static inline
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05  173  int brcmf_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint len)
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05  174  {
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05 @175  	return bus->ops->txctl(bus->dev, msg, len);
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05  176  }
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05  177  
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05  178  static inline
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05  179  int brcmf_bus_rxctl(struct brcmf_bus *bus, unsigned char *msg, uint len)
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05  180  {
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05 @181  	return bus->ops->rxctl(bus->dev, msg, len);
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05  182  }
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05  183  
e2432b67 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2013-04-03  184  static inline
e2432b67 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2013-04-03  185  struct pktq *brcmf_bus_gettxq(struct brcmf_bus *bus)
e2432b67 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2013-04-03  186  {
e2432b67 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2013-04-03  187  	if (!bus->ops->gettxq)
e2432b67 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2013-04-03  188  		return ERR_PTR(-ENOENT);
e2432b67 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2013-04-03  189  
e2432b67 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2013-04-03 @190  	return bus->ops->gettxq(bus->dev);
e2432b67 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2013-04-03  191  }
bb350711 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2014-01-13  192  
4eb3af7c drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Hante Meuleman   2014-09-30  193  static inline
4eb3af7c drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Hante Meuleman   2014-09-30  194  void brcmf_bus_wowl_config(struct brcmf_bus *bus, bool enabled)
4eb3af7c drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Hante Meuleman   2014-09-30  195  {
4eb3af7c drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Hante Meuleman   2014-09-30  196  	if (bus->ops->wowl_config)
4eb3af7c drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Hante Meuleman   2014-09-30 @197  		bus->ops->wowl_config(bus->dev, enabled);
4eb3af7c drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Hante Meuleman   2014-09-30  198  }
4eb3af7c drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Hante Meuleman   2014-09-30  199  
ff4445a8 drivers/net/wireless/brcm80211/brcmfmac/bus.h          Arend van Spriel 2015-10-08  200  static inline size_t brcmf_bus_get_ramsize(struct brcmf_bus *bus)
ff4445a8 drivers/net/wireless/brcm80211/brcmfmac/bus.h          Arend van Spriel 2015-10-08  201  {
ff4445a8 drivers/net/wireless/brcm80211/brcmfmac/bus.h          Arend van Spriel 2015-10-08  202  	if (!bus->ops->get_ramsize)
ff4445a8 drivers/net/wireless/brcm80211/brcmfmac/bus.h          Arend van Spriel 2015-10-08  203  		return 0;
ff4445a8 drivers/net/wireless/brcm80211/brcmfmac/bus.h          Arend van Spriel 2015-10-08  204  
ff4445a8 drivers/net/wireless/brcm80211/brcmfmac/bus.h          Arend van Spriel 2015-10-08 @205  	return bus->ops->get_ramsize(bus->dev);
ff4445a8 drivers/net/wireless/brcm80211/brcmfmac/bus.h          Arend van Spriel 2015-10-08  206  }
ff4445a8 drivers/net/wireless/brcm80211/brcmfmac/bus.h          Arend van Spriel 2015-10-08  207  
ff4445a8 drivers/net/wireless/brcm80211/brcmfmac/bus.h          Arend van Spriel 2015-10-08  208  static inline
ff4445a8 drivers/net/wireless/brcm80211/brcmfmac/bus.h          Arend van Spriel 2015-10-08  209  int brcmf_bus_get_memdump(struct brcmf_bus *bus, void *data, size_t len)
ff4445a8 drivers/net/wireless/brcm80211/brcmfmac/bus.h          Arend van Spriel 2015-10-08  210  {
ff4445a8 drivers/net/wireless/brcm80211/brcmfmac/bus.h          Arend van Spriel 2015-10-08  211  	if (!bus->ops->get_memdump)
ff4445a8 drivers/net/wireless/brcm80211/brcmfmac/bus.h          Arend van Spriel 2015-10-08  212  		return -EOPNOTSUPP;
ff4445a8 drivers/net/wireless/brcm80211/brcmfmac/bus.h          Arend van Spriel 2015-10-08  213  
ff4445a8 drivers/net/wireless/brcm80211/brcmfmac/bus.h          Arend van Spriel 2015-10-08 @214  	return bus->ops->get_memdump(bus->dev, data, len);
ff4445a8 drivers/net/wireless/brcm80211/brcmfmac/bus.h          Arend van Spriel 2015-10-08  215  }
ff4445a8 drivers/net/wireless/brcm80211/brcmfmac/bus.h          Arend van Spriel 2015-10-08  216  
d9cb2596 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      Arend van Spriel 2012-12-05  217  /*

:::::: The code at line 159 was first introduced by commit
:::::: cf4582875a77c13adf8fec79b8ab3896d2b38e97 brcmfmac: replace dongle command list with .preinit() callback

:::::: TO: Arend van Spriel <arend@broadcom.com>
:::::: CC: John W. Linville <linville@tuxdriver.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--k+w/mQv8wyuph6w0
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

H4sICAvih1gAAy5jb25maWcAhFxLd9u4kt7fX6GTnsW9i078SNzpmeMFCIIUWiRBA6Ae3vC4
bSXt046VkeR+zK+fKoAUARBU30XfqKrwrsdXBdA//OuHGXk77r49HJ8fH15e/p593b5u9w/H
7dPsy/PL9n9mqZhVQs9YyvV7EC6eX9/++vB8/flm9vH95cX7ix/3j9ezxXb/un2Z0d3rl+ev
b9D8eff6rx9AnIoq43l78zHhevZ8mL3ujrPD9vivjr7+fNNeX93+7fwefvBKadlQzUXVpoyK
lMmBKRpdN7rNhCyJvn23fflyffUjTutdL0EknUO7zP68ffewf/ztw1+fbz48mlkezCLap+0X
+/vUrhB0kbK6VU1dC6mHIZUmdKEloWzMK8tm+GFGLktSt7JKW1i5akte3X4+xyfr28ubuAAV
ZU30P/bjiXndVYylbVqSFkVhFZoNczU8lRt2wapczwdeziomOW25IsgfM5ImHxPnK8bzuQ63
g2zaOVmytqZtltKBK1eKle2aznOSpi0pciG5npfjfikpeCJh8nCoBdkE/c+JamndtBJ46xiP
0DlrC17B4fF7ZwPMpBTTTd3WTJo+iGQk2KGexcoEfmVcKt3SeVMtJuRqkrO4mJ0RT5isiFHt
WijFk4IFIqpRNYNjnWCvSKXbeQOj1CUc4BzmHJMwm0cKI6mLZDSGUWPVilrzErYlBaODPeJV
PiWZMjh0szxSgKUE+8grzYpWr7Vn0mDibUHuN22uprptaikS5rAzvm4ZkcUGfrclc/TBzkCK
lGjnlOpcE9gl0OElK9Tt1SCd9XbNFTiKDy/Pv374tnt6e9kePvxXU5GSoc4wotiH94En4PKu
XQnpHF7S8CKFrWItW9vxlOcG9BxUBzcxE/CfVhOFjY0nzI1ffUHv9/YdKH2PUixY1cIiVVm7
vo/rllVL2Cacecn17fVpTVSCThh756AX794NfrajtZqpmLuFAyPFkkkFeoftIuSWNFoEp7oA
XYVjze95HeckwLmKs4p713G4nPX9VIuJ8Yv7j8A4rdWZVWSpwczCVjgtt1XIX9+f48IUz7M/
RmYEmkiaAoxWKI1qd/vu36+71+1/nONTG7XkNY00Bi8ABlHeNaxx7NylYmOqi4FptQRMR8hN
SzQEL8e1Z3NSpa5TaRQD9+ruFGnSaMw2R2Ks10jgsOAKejUHm5kd3n49/H04br8Nan4KJWBS
xtQjUQZYai5WcQ6du8qHlFSUBKJhhAbuFZwezHAz7qtUHCUnGee6NZ7H5wD+oOA1rd17blPV
RCrmj0URWyjRQBtwz5rOUxE6WlfE93AuZwmxMMVQWBCMMBtaRDbU+KnlcD5hPMX+wFtWWp1l
oosiKYWBzosBNGlJ+ksTlSsF+vjUQg+jKPr523Z/iOmK5nQBDpGBMjhdVaKd36ODK0XlqikQ
IehykfKY3dhW3FN1Q/O6ALwCQUCZHZPK7caC2Lr5oB8Ov8+OMOfZw+vT7HB8OB5mD4+Pu7fX
4/Pr12DyBkRQKppKW504DYU6Y85lYEdmnagUrYQyMGAQ1G4PIa9dXkd9EcYexHrj5UjazNR4
22vJWFnrFtgOOqOAedawwS4O9iTMOONGMHRRDMflcDJSAXh3wtlAhOhNMgSuwypgUkbA4O7o
QpGbCBENeMhbdEG5BiW5vfDbVYImeFqTHePawckxHCE2gAEEgLmrKwcK8UWXc4wo5uQGciGw
hwzcHs/07eVPJw0teci79txvA6mRhR+AalNrho6nyKVoaseqDRo1+mZSqNMKITjQmP7ZDmzn
rnxGuGwdXmzHdes39rusearcHjtyBsd8z+T0VEb4FQ4NQLvXF+4tDtDxomfadZeyJZ9Qp04C
+kDrOicCVpFNzzgIFrAbdFELAMjoabRw4TqiAQgX1MW/DXjUylseAAOgRAaExUor228E7IHf
tmI6aDtgDqNBiPrMvOMyG5Uh9AcXQcGFR8/dz8mSYoGbbHCsdNTA/CYl9GYjmYNCZdojzMEC
Uwvg4uaZjlDcwFnfB/1MQTbDisG1YaYIquHMLGh+//X/XLxNT6kTQgGjEliRqHzlmpD2E9EQ
v4FHrGAWInXVwlo/Ty9vwobgqiirTUZpfGXQpqaqXsAEC6Jxhs5J1dnwI3T1wUgl4FeO6uZu
rgLLLCEItB3SOKNB/yCBqzgnYuHuOEj36BvaqU3p7FZPaS0AGnD6iZ4oUTTg3mHZQRgIRRPI
EI2Wa750IbgEk16Ev9GDu1mjhwFYkYFOyZiGjE9piPs4ftb4W9P7ZViCU/RgtXABn+J5RYrM
sUKzhS7BQLjM8/WgF+fPaw7RIzIXwp30jaRLrljfj+veQIlMOuTOoqa8vWu4XDiCMEhCpOS+
zpkyTBp1RFbboff2hG0N6ulKlPV2/2W3//bw+ridsT+2rwDjCAA6ikAO8KgDh7wuTiN39Q9k
whraZWnKIJF5LEvbuo+7zpr6Sp1bWVAF8bIvVTRJfN8LMcUgiQmkWOhoJeR3opyyNM1Kk120
kPXzjFNTiYrpoxQZL7y8xjgXE8hcQ2NrRo1Su2sQtnlM0c0p9fyhn55iEJDRUre/X5qyhown
YTEbGCpIA67HQUzpGRwAGAHGOYrAeWpCLIO94HhoTeW3CLI0PHqEfoDfAZCvSFgX4bATWGyF
OemAtQgrXZYqmY4yIGDEG1gqFo6ymL/3HNCQshvRuRCLgInlX/ited6IJpIPKth5zKK6TDdS
agR8sAEgg3mnCQamdB+MIlkOPrdKbSm929qW1OFUaRGbH8iFqMrw5iswJUYsugp4JV/DGQ5s
ZeYQxlMEUHAAjawgI9BgEO5NQ+hQIltruJGOezchuwWnTRlqitm/QbGDje2PslUkg20pa6yT
h5tlqbaKN8FLRTNRQkZUaSsVfV0wMj/FKPqsFkxTj7YmB1hTF03OfcjpkKfMDSTMvqCVMAqY
2MsMQmYcUPkycHwVO9sLHlNTEBkH9iNpUGMRTdGHzVlxPQc3YE84k4jlQ28wTvonbLPCqhHr
KvuYtTmBUKRNAQaPrgcRhIwoi7Ic4/rHlxzja6dAgK3BU0YN3G/12T9FUW/6wrcuxg64n9s8
BrIVAT8auADIZitwr7CdKyJTZ5ICUm0AM93NyPWIQcxdoXf8Neb4jl/PsngWNMx02V2S0cWo
cJJTsfzx14fD9mn2u0UT3/e7L88vtgDkaL5YdqXgGD7qj8qI9fHOq9BZs+o8r/XMc4Zq4cMF
vGVwSisa4DnAQFf7DGZUCFFuL52s32pSZG69jpmqSwFRovHSsQTLDLHQW5lbIxiqBkNoKr8a
4V/0EC0wRshyFUigXptCdmq6McXOaRG5CgS6CkKP9ur97nF7OOz2s+Pf323N7sv24fi23x7c
o7pHTUsnrgIg5k1cWWeMQLBgNnEf5mBYWJDt+XgN4xkESpS18beRrnPQ44yrediCrTXoO94u
dnlBdLooae/fijoKcVCAlEMvXRXESc6Fytoy4V7VoaPZyDvR6+l0u9uGjPCicSsc3SUgl9zb
Dlt7AIXQ1nG2JkZH60DzDQRTSCbAJ+cNc2vMsJtkyaVXJO1pk7NeADzv+xnSwmXZ4fsstn+F
aTBudhrsnwu7J9GgYgc+CguM9p5zMNSPn2+iR11+OsPQik7yynIdM/sb8+xikAT3Cnl+yXm8
oxP7PD+upj33Y5y7mFjY4qcJ+uc4ncpGiXiFrzThgPkJz8Bd8Qovm+jERDr2dTrRd0Em+s2Z
SFm+vjzDbYv1xGo2kq8n93vJCb1u41Uyw5zYO8zXJlqhm54w9i4w+cZtzBZrVd1DC1u1vnFF
isuA53muGiIh+M144WxwbQimEXD4o2NgMB2YKqtqSp8NFuETOlh88zEki6VPKXnFy6Y0OCKD
5KbY3H5y+cZbUF2UykHF3e0MokdWMP/2BjsCb2lXE8egnYQ5cnCaZ4XAncdgcd8FWBppnJn1
DIM0Swb5//VVbHZNSYORey9cM33Kyzta6qZDlXn+oly40d8rITSPl/U6gaUowHESuYkWIoyM
u8m2kXG2Tl0J8yjNTPU20JEaUSYNYyuehUDGhNqZrKpv6aqjiBAlkwKriVjc7R52oFvHBCCA
CSVlI4JVCp9MKotbo/IIutUcQMMIYpjOfmF06s2dBjwJsBByvi7tsqDJqY19270+H3d7727T
7AcDmL0BlOy+1PN/aQEWnjg31/zzIpyhZLgxGV839RRU8WzKmGfdcG+plcCb23gZsuN89Cqv
HfHmYx5VxGWp6gKwyHUsdA9MrMm4vfacq/O9XpmGZ0Uu45ghZ62AxIXp24u/kgv7v2CdAVLO
wAiA2rKKRF6WGfw5zTZOq4dykBK4OskLVICiB2r4EKFht6fZnG3bT6okVUO8evwwI8uLlbht
Y7+31kQc284prAzd4QU4Dx+pYUnZh18euevU7dA+JeWKQj4aad4tF8BpQcIM1HTdYTv7Lgy7
jyzQakCtzRSMD/0Y9J9gqTnIb7GSTCeKtyXP5Wg+9XwDSViaylZPvsq1YFZgZu4ssmwixbGF
8l7m2RdOplpgn4Ok8vbjxc/+w9bpbMG9mHY48fcNkWpJ7AGI+ypz4UyWFgycKwISh2beqg27
C6n3KIEYc6PJAnLxHam6Pd3q39dCOOZwnzROmeX+Ogsc+b2avFvoawPmgWRfbJ7KuOFUmJSY
VpuSrPUnXXwc0jys7RoOVogXQfbiOdBaxw/EuGjEX20CSSNeBsimnlBNGwIAyy2xzrC6vRl0
XUv/iQL8bhWB6fL4AwEDHkn43BgQoWprLE2YIw7rWbZE5ocXZfdwuGPK4nC7K4bG9+e+vby4
mGJdfZpkXfutvO4uHEd1f4uEMIOeS3x2FH0FuWYe5KGSqLmpQ8ciDfgGjnAH3KbEYHPZxZrh
tpwhHjJPT861N3cn0P7KC1XdtdcyVcK3stQUj8BJxhExhBGebdoi1bELSfdYbTzrvcdcaCxA
n9DN7s/tfgbo5uHr9tv29WiKQoTWfLb7jt8rOHd/XYXRiSjdY+yhyjScQMdSC17D/Kro602I
RAVjjokCBZ9cjKkrsmBBaculdm+BL4dd9bg5dZt5fr+crIUAy7twWd1BeF+ByxzKpp1nd6yI
uhVb/NUjQ6McaqgeuudT4ocBXa0Vm9TuhwCG0t1N2vHNpwrK+djitBoja9aTR52C7avbXL8V
ZmeZsiNE1c1ISbZsxRL8Jk/Z6Qn+tDijZ0KBkSDhShOiAUBtRvNLGq2jPtNwlzAfEfSUkSqg
pH4Btl+2TUpp/wXIeF+MwPQqaaO0AD1SaQw1nArbRtY+T2tqgCDpeDCPOz3glMbaCVM8YhGk
eaDMQX5qpy4gswQvE9I7H9HlgKEyJioU9yKJsyeQTM9FOlonhN0G3wfPATiuAA60oipi6e1g
EqRmo4vbnu7fPLri/qhGNp+z+FXHIAI7yMi0/RgZBnlkZMyW4actwW1sWuvMGlbQgq0B1ua+
O+L4GEqyPA4Q+kODf2d+yXgiKpPaywL7d7uzbL/937ft6+Pfs8PjQ3hTY8o6kt1FW/Knl+0Q
ElDUf0bcU9pcLNsCoC6TE8ySVY13SGgpCEzVIEdFUxf+gxYzk+Tt0Men2b/hwGbb4+P7/zjP
VKh3/mgUuUAAFi+1GHZZ2p9nRFIu49UDyxZFTcfDkipaugGe7c6JTUDr+nClzDN7FXZMq+Tq
omD2aVB8AIYBwktXOt32CeCnJR3JdKWSYFiA7nWssGD6qUsW9JwGiwEZXfrLKxUfEfxPDrxl
T2ceyJX2+6se8iCYmNh7pRvvZdHc1KMmhIkebT8XywnhWgYLqoniwXuu/lXDMHzncVGXQ2VH
2m+7w3H2uHs97ncvLwDYnvbPf/gPs8x2r8w1VngIKy+nsZfLE9fO3YsSp7ShnJIVG/1ql0WC
Ky6923vDwXV2DYbswTSBRLoBPCyDx+O+lLlFjKcaFCF0ZAGh/eHvdi0uP0ETHnOnBXfeB1ZM
f/p0cel2kDMR26iaYsnD14iS8tijWxS0Ftgd5Y+PD/un2a/756ev/qXrBsvS0cGw6/DzIAmH
lLpvCjtCqxX/6epyTMc6jcEA5isDN3npBDqTketWr1uTI0cmc+oN1IRVOfeflZy4EwBlGKop
8RbehRY9j85LF7j15BJn1NKULfutlA/fn5+4mKk/n4+Pv40NwtmQTz+tIwPVql1H6Ch/8zku
n7PqasyRa8O5Dqu5+Lo3GVkz+2v7+HZ8+PVlaz4ln5na8vEw+zBj395eHoKcC58zlBofsDjW
VWTUeynfCSkqeR0+9SJ43qFkRxyeMFhyyVUsT8PB/DdaXc56HX7d2D1j4MIrvNQlNRzP1Ppj
rLbHP3f73wGCOAmnc4lMFywWcJvKNV38BRpOHBe0ztzn3PjLfEUdkFQD3ksUnHoZh2HZOmG8
eKbbBfNadKRYo8HxVhNfXwAdv6fFEkpJorEcu691DQkpgZwr23g7adrW842xbshiytrzxSAR
PlA7kUKoOjBIusTn+ml/TCmjr9vjf+NxgdYeIQKFf9WgR7uMms8qshZ2ImkgGgkX97rRH35A
IKzcx/7aUZsEsszc8y9LkG4/X1xdxuK0HdgV76ZiLp9icL4o3I+OCupoM6/X3o/uJteDq5oU
sbNaX31yeiW183VOPRd2in3HjDFczqePMVpbFd0/zPcHcLgQIIqopMLvDb21l4Ra3oQ29d8h
mcO9e9u+bcECP6jH37ZPb2E+0Mm3NInte8+d68RTJEvMFA3tBOlw9FOmYPj4VdpZAfPNxbnp
SDcn7Yngj2PEuzFRs7siQk2y2GpyGX1z37NThWY97g3+n5VjcirlmFjemQ/1RnQ6Fws2Jt+Z
NY1PEK+ezsw0u7Mi4w5jezSfR3ej5lNO03Cd2iN9eTgcnr88PwY+BGWp+11ERwgxQ0/WlFcp
W48Z2WpMa4LLfUua/GytY49PEDlSLes49SYymUKswv1COh19YRau2v0Wye0t8OmGXuIH1N67
SeQwQ47R7KNO57tTh0XLOtqkSjZ+qczhNdEXEo4APrCI9qrZWsf2h0Qz7p7Lq4idZzzziukp
TSJdJOCFCF7HLT0sdKL2/4wleo5URSeaT9c+l9ZhOxqOORFAyX9kRD71hkUXvFoY/DPxtqyI
PjZ3XxIoc7/afaPpf2BviQaCWBc02M7AsshkygtCUgFJ0Kb1v8BK7k5/H6FDgbPj9uB/OD4n
pSQ20bEJ1MPj79sjgP+n5x2+Mz7uHncvHmQkEIDjN5MkVlLjMiV953yfEq/Tk0xBvL994Edx
iWfipdjQZwsBSpIR+jdDjG5WTIPub/HgS9lC+Zduhm/e0MoYkDHsHsrZYV6/7B/226cfv+/2
x9nT9o/nx62TIhkZxeWYc+pR600LEif8t3v9CsnK4e079ujAPVHlhecLmOIdNVrA1BzSoqFZ
R9dsIUk5JgteXl+B+w0ZBdfMKv1o/JLcXFxMzyDnMuHFqMOS1leXVxcjOr6hT1ixwL9zEbBg
LVcXF+Ou8JpYNWP5hUrJ/T2k2GPGz59+Hqhmv7Mzh9OopFfb3np5Dj6UFfi3lRxvCBm/R1jx
KhFV2hGHNwP2ZRKS4/WWEv/YCKWTAqTgIe+E2BX357DkxCeUVIUTSuJ5ktKSgZKYZyyxwVb8
/xl7siW3cSR/RTEPGz0PHSNSUkm1Ef0AkZQEF0HSBHVUvTBqut3bFeujw3bHePbrFwlAZCaY
kOahbDEziYs48gakLMJRaWdzpPRUVrYgmm8g2+2BV0ZKE8d5J9ZTHdx1yKbnqcFPvChrcKI4
ixaSQ/HaqoE+K9puiCrs64rVwaHSnddIoyOVT86WKZETWkDTVuxz7gQc2wY7yCR924A+B0dz
KbcWwbnXOMEDDeYVYq1gWNE8INoM/GLg85a3sT1OoMYSnGIUgxfOzYquFt2/fXr7/O371w8f
+z++/w3vLZ7UCNpc4M6ALwscoTOA/VdjMKZAffUzCZKj0Let2eRW1Yafs3FFkO3OxdLPxwWi
cBY4++hLtQnCxhCmdvck8VHtnoNueaCsGqxi8tB9Q3kFYAMeOS43ExKxt/A0HGXo6DZQU4JZ
cpGjXUJEITfFqx0VQHfmI8u97ATvVQH4ilUWA+aQYadeA9CH3CoRPBPz+nW2e/vwEQKnP336
67MXbGY/GdK/++0c7eNQgAKD4+E5bGJTrZbLXqZ8zMJIYV6PNNXgFwvaWAuCYWJqM4igNtxI
mbW1j38jLw6I/+RlaGwwel2amP8FD4Uy0Yl/7o5VhdftFeLlo5HZh9xPwEtFmFEziYB1wIvw
2frKjwjH8rjjN6dck01Y9/arB8/qkJU7uvD2Q1E2WDwjYPDMOqAcH6biTjXUonuF9QpcuTnP
yE5UuSiDyM6mdRWZE1VZ07pNxcN5jp77shbEOju8Y5gdF6g34swB0IqBArV9KMdF9A79HlrE
Ehhmtiy3gvXOsgG4kCVlqncG4945ggugaCBhf8tbeYp4tniC4tSy0X8ODZyAL8Scpqo+kVEH
lnYMxWJrGXJ+NUcfYcZVhqnAeBlafYo90ay7Z7pQPEwpYh3yhDjtGthwbIbMHDIq7ehXA6SN
O5mmmEIUzjPUr5bfX//66GyUb//z15e/vs0+ffj05eu/Z0YOeZ19e/u/D/+N/Aagbkj4okCV
oMcjakBA6hFQeO4LnJ1qQGuz7t27US/UgW4s6j6tYQ8ibqsjCT5DrUMr+PWBdtacn4N3wmS3
N/9V17iCYbGCqTrINae6nDyAJtOGSxi+N6AbUM6RwHpDWx/sn3Fca1iEzeJgHRZZreWUHjZv
8NChdV8dFK/NIhXWOwfn9RGGQLTrKYUdvOM3s60ql4rUJiHpvr5+/uYMY7Py9d9EFLJ11c2k
fihaAp9tJrcycjNd+s5+KNQ/2lr9Y/fx9dsfs1//ePtzKmnZfu4k7fi7Ii+yYGEC3KzdwUpL
GmNKsPqg2vr9shHGXW6zEG+FEWnPMu8OfUILD7DpTewybEGAjwQHMo2IRPtNKVmt37XzMuiM
haXcMMlI/OMVvblVC8QJFTjJ7jD4yvAEOVefOUQ5m/sVfexkGaw4ocJy2khCGTvNt7qgp7ed
e+r1zz/B4uknHNiA3Qx8/RXis7E6yzalVo3pGYx5E8qZeNIfnkNvbQT2RttoU69k9S7eG5Wv
Hy4tGwMJeJkdAEtHrNDbdALMnjbzpaclVehsm0IQCxWvCInh4b5/+BhFl8vlfB8JGIU22oDJ
E+TE4HQIdiRK0bnv7PRkHz7+/jMca69vnz/8NjMUUc2MfVtlq1Uy+QgWCjmvdpINNh5pJtKP
HZfStOjGtwuweKF2uevMCANVW1d34NIO8iEORfHYorU5EgCbpP5Uy9++/e/P9eefM5ioE+YY
1ZjX2R6JHltreDJSd69+SZZTaPfLMvjAhrGNdMZs6ICdHDcO7PI2PffnVrKGe0w6xuuyJdUd
J6tiivQCu/0eTZSyyfN29l/u/3TWZOrKArETxZLRZfHehkIxZ4tuJEzYYNfvNsmPH1O4J7Yy
zdK6FRjWYHJEHrec6Jh3iJWsd/g3eFl0HUkyYIAQcAaJMQjQReCwKNM5NQH6HEkEBlFSRJk3
wrx75wgnfG2964l+3jwr4ioFrQgKsB59QSGmprqkfL6Bgvt7KTiPztCX36UQCn30PYhz9Kqw
z0zVDPoeqxkaXcgY+4QW7uWxlqoJvV1HjI9ScCfR27dfEa86SjRFZSQZCKzQi/I0T7kFKfJV
urr0eYO9zRGQyiVGLlPPdJDlVvUCh8o1ByP70UNB78HXMuP8GDq5U4F214LWlwtiOGSmHxep
XlLPPiPalLWGbCQQbhWRxg5GYipxXEGT68fNPBXYNi11mT7O58T7y8FSzkfxOrCdIVmtUBDT
FbE9JOs1A7eVP86R7HFQ2cNihVjBXCcPG/TcgL39QP1cwXigzxIMrjstHpcbPvhK8wdKlgYa
Yvtsvq0hF22fJrZHzs+tgKWOLEbj2FtML7qU+6oe6+JmkALCgY3w9bBZrybwx0V2QTb3bLtO
5pPMew4a805EWDMr9VE5dv3an+7Dj9dvMwlq4b8+2QyJ3/4AE9vsO8gn1s720TAIs9/Minr7
E37i9Nc9TY6Cl1eoO7O1CfCxep3tmr2Y/f729dO/TFWz37786/PHL6+/zdxNDWP5Any2BHCz
DXYQsqwO0boNoF6RkRnh3YWXkk9ONXRSjIOy/AwMmdnAreTreILBypjJHQM+1Q0DHQs6gL9z
DJmBCy1TTZT+y59D4iP9/fX7B8OAD/FuP2W1Vn8P1XzQvqG461TLDtT8fSltLileq2CQYne8
6oxqNqDf5UHLB6ufzrS8MpcTUysgIeqPzCOARTM1AdJ7B3AawCNNbOeendlg7/g+iinr/d7Z
Jtz4FkUxSxaPy9lPu7evH87m7+/cct/JtgDTHNvGK9IwLPqZ52/BIAImSj+U3Dg604AkqaKV
xNrmIrQD2uMIbSPvj6KUL6FHTVcINYXYEH5yAQAxc4wkbX2scsPNST75TUAcz01KCcGIfipA
exp1GxqJQfe6FSU4c2KNd3YiLg0GoAvqWQXMeV0WHGzKrxkc9e2w7iK1zXVfda35QdWLLahm
eFm0O1b9yX4ve1NHJL7wVHScAc57yxD+rypJsn3DphG0e+6TdJ5MgfPVFNiK8wSWBYHmbr6p
x/mPHzE4SQjsS5aqlxx9OjfMRBRBYzRCJGF1weXWLyP8OSwYFgRv3nd+uoINoeggX0ZQgwGE
nsVXsPm6YJNosRRxxVkwRB8kD+cb2M0t5PIWMo0i25uVtrcqbX2lZLgIOj1HBg42P+fUQAt/
mbhJv9gvNB3SSkLcassCrfynj+HHwViZd2vD9KwohYWmmLHE0Kl+gmDb7NRHYtExGd82ocx5
qkVOc55STDz81ZAd6la+1FX4tgffCB6zjeNUgfY7QUaw+bygjb1CbV8gu29ZdBEKM/faomuf
8WV2GO+GdE56Ukw6UQyjFmmn2ZvrgV8FmzjiTScqCGsz7zpierYwbYPEDWcSN7UfNB9uapFu
D+Y4e8ivRPZeL5eTc+5UVPCVFxmrZkQUIhdNR/M4eJDN1LCTbC55XMC+wBxB0SWLJHAivlKW
IgOdUkaSUOpSGt4xwo+Mr3YFOX4yszfQRluIy/fYyT1cb8B9X8fid3rieHutSIkXNmiY0NBg
bJVvkiTp+bM04BkaOFZwxE8lH1ZBaf1lv40ErnukT6mbsd4CqKFtxn8ImEI1jj/vSrJPlQl9
ClZRmfAeFSKSYhBXfWzrlme0HQeQR9L0oTIcy0gVHNslb/PYZgp0lOz1OtUFdTqrMCdmZxDW
vhpaNKldJolQKWWIYj7WY8szl7JgeEWwXygTJ3lUPOpQlBqzPR7QdwkH65M9A15ysNOOr1C2
LY5+zvTm8cecbHgWcjuDLClQZ3xcSnbp4RIYTqNKmdGxsLyYhMZ0x1LyKXTwe6E8xxEV6lgW
d+d08QJJO29/+eKC+Qud0h37dInklxreP+Dc7k2C8/YgqiDJX0HoCpruxz4W4XN/OGPzuNxv
yYNBEzHAgPCskRdCD1tV8DgpAICkiCVuFDxh7E4l8ye+65t0hQNR36mCpVOiPRVYxlKn8PxU
IDiJfsudnPqJBtPBc5SXskjYfrREY6qfnlNaxHMaLQK33DRbVDXqoyovS8MkBwAqoVtQwPMa
2Gqi1huApkTOaFNe9HlatocNnxUXd8X5hJC8XsKSBfH6ATbiFYdGRmbEF/VJbzbLlD6vElMa
oXkxRBcq2O0KUVY881IJwzSQbKQTgN4sNinZGPH7BWT7rxV/sCPCzeKRVybjwk4yZ/lsRFM/
kQQKh54sRkgpEzAHLkqYCUg/GKbI7HBMdc8FuJLt8JWWqAXvy3qPD9X3pVhc8Bp9X9JT1z2H
W8T7ch9ya5eiAgmMHab30SjCa7OOovSxJtdXzCPET01OEv8G5MPoilhI8UBk1rmY3Ix2xeZ3
5nALkUktO45aKCOu4Os/7U5adIdIZbqgaWdYGhlLJk2IeN8jTFKXRkowf3cOMK1oDKtW2WPy
yJouGpmRgwtefUysUIFedzCfGaqunzgJwlIto2tSd9at9m4Xj3cEAv1c1Y3hCUkDPazPzxl8
qv59JG0OKqcrDseO3wkx1V2Kk4xz2J7kLF9iqsNdnrPu0BAVuKU8RHN4dhf7Xjt9bvC9uCXc
XttKyKPm3bOdtdSct7N/Dt59jF0f8kEYzh1s5QonN3MI2W0FXg4OetS9OpI5guHWk5471jAN
eHu2RViy98HHoIOEgBy/Y7g+STkzXYx2yd6NgMdGmG2o6iAlCfVbF91mvrgANCbPrM0eegu/
Wd/Ce9kpJLgy4NLIJ5M25UYaib+TN+bcW25o9yzwYU2BO3thEgHJrCnN6FOYNaNdzuKZwiEK
quiSeZJkAQKCkTDAM3lhP1Sh66rfX8ro8DhOItJRu1kAqz8pFxDADETLrWy4kohX/J573eP8
8UO7CFtb2A4jlCbzCyeJgNbDLGCZ6fCdk+wKDSnuIw27wBVtZvmYCZ62++Dahus20GCfi6aB
e4TBT44C8wJcWQoKHJJqjE4XBqqahs0BCihIWUAjDwy4JrpeAAT1CMieGVYDMFDecSdHia8E
1+WBHl4GO1zdyfIblgIyFnST96xBCX49MO+BY4ENr5iaFwBlhGOe6wHkkzjzOihANsVeaCzG
A7Dtyk2C3SdGYBpWbdiF9ebCC8OAN3+8ngWQB5qW1cZeNge+tWdiU7uGI/ZnHDQFNKMGU5nV
gXbWXG1c6NxQHyHveKdISqPYDA+YBmmhrnvrckEeYDMWFKL1NiCxyYS31gEeEr3SsCJKwW/o
A4lmI7cAb5OvQUbY65URFGeFNIInpeucPTmvHezJ8WiLnAAOz/1+CqqmoLKZwg5Bi2n4HEAO
57YKyg8kXgMKXWEG0K3hGSmmgzShmjTMw6/Nw6PqUTGxH1VNdRPoVT9lGsjrVUcynVLykIyr
rPeRugO/kCnqvw0QTbgygOxYiL2jEli5PI5Uer897hi0DtQyA4IPURyLzWTQARQPiqD5dh/b
I+IaSkwVv2clpGqNtHWX0DMtd7YdVRjJn+x3qls/zJNjrC+tiGo6CVlUxiVUOM2keegfsa0H
AJPgXABqmmTPQI54I8Q1YJN2dk5SLG64Z0dOi8QldBLDkxQ7H7jnyctJitUS5nlDn4Pgd/sc
FmKZEnT/GUn/gdv38pyLycH+koPrBDP6gEiSFhnOrxDGxX2IET9ryavhr/xFW+VS22ZN/NDO
b0pcZuCI9PHDt2+z7dcvr7/9E/KZT4KxXOizTJfzucIjMUKD74wxNGJ6nJMRrQTK0xX3YNod
38lOH3tyS6aNKPTOLGNxOp/2XH7+86/vUc+xIELbPgZ7voPtdpAlnuZQcBjw5XHJFwnY3Sny
RIISHUYJIz9fPGYI7PoIX+MN7pT+/ZV8EP9SbfgBVw1yTcSYvtHiyAVQBGTaSENF1V9+Sebp
8jbN8y/rhw0leVc/M50tTmzTilNwEqIvEguTcG8+Fc/bOsgkeoUZZpDnlxFBs1pt+FiugOiR
GbCRpHva8k14b0TWNa/SRTRp8nCHpnwyNdwmCZUcPIWdhsWdorpMPCwjkWuYaLNM7gyem8N3
+qY2i3Rxn2Zxh8bsL+vF6vEOUcZr4kaCpjVb7G2aqjh3kVv+Bpq6KSo4Ku5U5/W7dz6cv7/T
R7reKbGrz+IseIl+pDpWd2eU7lTDs5ZjL83uxBvfB5JLd7ci0KD0xZ3FmokmSSIy6EBkhBL+
BBn3rejOZ7YsDdedjJvWFWJ4bRHkmR9RC04FMKJzyZSX1dtWMPD9Ln1ia9m3Eas2oegjt8eM
REe4Z0vVnKg+EFmmVWAxZ0BpmRdnyBTYsq3sVGTHHcs2/FHGz6mB5izaVrKhhQOJEntrEGVb
YU7UrKhbTk6gNFuS5G/EwR2rsR6eZW4ebhX9ciiqw5H7ukKv5lQ3MaDguDze+3qXRnBzzc1e
e/MF+mbu2fJ8pqsZvnkbo2RD5AmE2ndZzSIOojoLKtQi7NPWPLD9QEReIcUpKx2RLlopSjMV
slotQy6iq4/ZwbEeqIEjEITLBlJFYVYQ40W+3qwfb+Fo4BXBt4YfSjx+7BumAAVSr1h/IEJ3
NKexvGQ4lRfGb49pMk8WsWpAGQ23TMus2iwi5zChf95kndonCRdTRQm7TjdhWNiUIDpEDh86
I3AUN0YRHOSbllM+YaqDUI0+SOrNgAmKouO01oRkL0qckGKK89ORJ/FyB4/c13UuL7HGGbHR
fGL+SCOlHKsX7twiLX3qdmmSriP9IHpViqljzbOrrz9v5qxwOqWMTgjDmSXJBkcHEGxm9sX5
PNYKpXSSsMGLmKgod0L3SjbLaDn24U45Ul0ejqW/2Jf/ZlVxYXWipK6ndZLyvT10WRPdt4pK
+Wtn+cmcGwGzW13mnPUAE9rfLQTSxoqyv89sqhbSohv70znvrLkx+tnPhmlPIgvrrB7Xlxs4
7FEf4mJDa3ELHmcNKLVqai27yKYEJLf2AntwieqdjA4qUCw4z7GQSHbqVhlFd2y3vDAXkk62
hihlrjKY1wkvaU5a2E6WS5w2j+oPJ82FnAHmYLfwW0Owr7uaNWYGdO8gNU1k/tmhjG9vFp3e
Ox2sgu4Z/LdkdE9w38wwJtlyFSioo/T/yTZiyxX6+TpasXUsuzTOJ5hvbs+v+/PJUKbzOS/O
TenWdxrfqp5mNcJILcuCZWYpkY5vLrpL0kVkI7CCawR12TzgywJIvxr9sJqvI8v/xYouEX6m
LuW2lf1phw2qZDTqg3IcXUrj3J1gyl8b0iq5nPhqWiDvFmlRWiGtq4Xs5osAkuY+fnpS8I5N
SepRaVjwYj6BLKdFrkg2aavbO7x+/c0GZMt/1DNQteJLMos2iOwLk0IEFPaxl5s59vt0QPMv
Dbd34KzbpNk6ITyHwzSZbDSXicmhzWc26OlrrTizy8ZhfeTJrYINTpGLMP2bbdazFYpmGxQX
ENibm0SjuU3Uq8U55elxslV4xF6ogg7lFdJXerXaMPByyQALdUzmTwmD2SnHIrrYqz9ev77+
CrekTCwPQcTVKXa5zeOmbzrqmHc1dRpwdOjM6VRBVh3IDdmy7qT1S018f/s9zsBhs/35K1NC
qCa+K4Naz/XIQ/Pi5O4jH12witNTcBm9T6v09e3149TfzPfCppDJsDetR2zS1WTme7Cpq2kL
m9juRrI1/EKQNgWjdqBJ4rgCTJSFQdKkNfTebFIvm2IWU1Rtf7SZ9ZYctjV8tlTFLZLi0hVV
jm9BwVglqmd3y1e0//UxlqkGk4kMcivGCtnWGefsTdspwHaaPGQrfLRhksNx+xCrwWawjFzd
R6eG4bQ6mn+GjKiOfqyd5kzbpPBzpNAu3WwusXLLhg0eJJ9Jxr5ffRETDCQy8lbc605Uffn8
M7xgKrDLzcaCTlNLuPdhNpVEwggQ0flOlSUIGH3jnVbMuOgsq1g3wAGfPEgNchtb44COYyhP
5rFmLW2LNhf0JgGP9Offu07sYRzijfOERxEe2RQHCgW38sJ1i4m24pjDVWK/JMkqHe+1Zihj
IwyRE8fQjY+iru/eOk68G2Wj+7D3k4Fqef25R7dNjIEwSLPGzHqINHdE/icNNk9mT4EcwnIv
DW/LKuPheoumNVs8OtEOp8xb6EeYTygxGWPZKAm65LzE1BZqpGzp07oSXnnE6c7UzFvNLJXL
ZeJMGTsRsThYSs0dIw6j5W5S/Rku2snrG1Xbe4rrHXcV0uHsU5TgYgegu19a1sFRPyELAv1G
RBCbPCL2Be/8NVKcpOBfjYaio2Y3OFj1RFIl5l1JDFrt4vGBFzBF00AwOG++03X13HAfSp3F
iURYb9aLhx+B2z7c4hEm0z80kQgIMyP32aEAWw98Dm7iZ3vf51G0BVAkXsbjYNeM+pZiGmkg
FQl4x9jqeKq7EFkF6spsf7Mmvoas3VLAyXQSTCmX52lTdPf/jF1Jc9w4sv4rOs4cOob7MhF9
YHEpsUUW6QJLonxhaGS5WzGy5ZDd77n//WQCXLAkqD60W5VfAgQSWwJIZPr+x94L7Ii2cy+b
vFGCx8MIVbcTMEs290qo5YWiWfWtZO5cUZiKwHbYtNnxNCcBfc1FuBMdHGG+JUIvktKkBGTh
+1WZD5CKAdhLKrwVouJNingj8ufLj+dvL08/YUeDpeUuQKkiwxpwEJYaPAhZeTqWakGWBy0m
tc+zNAxcG/CTAOpTPpwbvVYIgYwstSpKNamWsG3GvG8KFZh91qMNrQqwVmlyLoAGA40PJrHP
M7nB1zME9IK2iXKOEnwFOQPdHvVZqXHW1G7oh5YaczTy9RIBcdSJbRGHEUWbWJDIngVnBL1H
qMRauSjhFCaf/glKq8mnr+sxUEknfmDl6Y07k6E8aWKrMKthS5+GWlPVLPIdPTugphFpTgag
WFZUAswoSyvikCQiZ2GueVsrg/uv7z+evoiHY7PH5398gaZ9+evq6ct/nj59evp09a+Z6xdQ
2NEV9D/1Rs5x0rC8BRMdm9XHE3fSp+rGGijtECwM8rtiDTtk98M5q7WBUx49x5hcyra8pY94
EN2pyE3ZGiOw48ZIWqfJM7kySvb9SL85mDHrs23Ezze+rUewulXO65Em9OOlucufP57evsJG
C6B/iUH88Onh2w/74C3qDk1sL+SZKC+v8Bg7NfqNGC9sd+iG6vLx49SBwmfJYcjQQulWa/Kh
Pt2rVq6ij8NUtxys8bJ2P/4Q0/5cH6kb63Upm/JmIPXtpcEUV2W8WwvrqUmP7iKCvMO6p5WP
eyYiSLMjUF0+wlYXe4+1vWePnzBFv8NyuFjO3Xq6MzFQqCndU7ZEhx/Kmi3Ol0Gt32b91Scl
J788o+9RKUAiZIDr+JK27xnlhLHvzUgLSPsdw9k8/Hh9MxehoYevvT7+11zoMRS1GybJxLUi
3E1KSuy6sopcnr9qVdn4hIIhpYO/pPPFORTKBkhHitgc85dI0c8YrlFECywoq9VAfCt9dENn
NOlooxlHsie+BemzplVN4xdkmTF3igEK+/l8f1uXd2bG2nZpzRUUW0WRXot+OZ1rVvZdfZIP
u2G2VZ47d5WmhXGdbXYMrSbCIzO01jEbwDKH86zYPZOfUnDa5nJdpnLDV2dTNYXH9C8P377B
qsg/YayxPF0cjOMS5WYtmKgGPxyxlQy6RD/oFR97z0k1YnGnBO+Wq0AsogI+E1Kt5eHBKc39
aSRaaGo7dOmpEUGSudzSnHg7JmGo0dSFqIcR+8ssRbym0iSpSsx1AlyHpiChp8mVqUYui221
zAQ52eRfxa52JipExwVAnR0IIQ5JrAvGkCtQfFe22eDUO+ZGeZDIChkXxtPPbw9fP1HiICzr
VfikN5LoxI5RK073KHVCmLPj1sY3hTHTLcfaM0uVhLFeV33m4sShr3MvcVfP3G1VmBJQen6W
Okb3+i07fZyGodHIurYmOnjvp/KT0lUW8+yp1ZZPnvY+ZbfkFtVbD29tshJX40lkyAXISWSK
C8ipfF0supFmD7QQ0zRYxxxole91LbFpstfmMGhPlRURwoLQXRPdhTZ14eC5yH3PtWbJOvSR
0GyRZ1GbeX37O8MEY+b6zEkMxQKtSHY7mKJkzsCd+u7ZxTNXI2f3l/9/nvfM7QNsl+ScIYkI
9cTfbXSjlt2MFcwLLG6KVKaEOq2WWdw7+enYCswrgFxc9vLwf09qSYXOyv1LaeUUCKPPUVcc
S+gkZFIB8ahdtgh7Mqtsc6bmEVkAz5bC15tQgvx3yhFHDp1rnFgB6+eS0qFsLleWwwcvVt3B
4LH3lN2qKhwnwr6TdA4gUIyZ29ybqQTd+kq6R1clyGjqu1mRYxB56EpKtmL6maxev2d8yXQ7
TsXAhZxKJJq/gx7FkzQI5Sf/M6K3jExPbHSlXRSEGlMLA9p8UAmFseVOQnZgZkGwiRWXXRqg
nvDiDgp9/cDKp3iVWAu/0LcDWVAZcQckEtKXAoKlupTNdMwulvCDyyfQzDh2Anpq0pgoMS5V
qFmPLGbdIG2SqnFKFqjpk9iLyS/LLJbHhguLZT8gfd8NwjgmSwaaQeqbCDRW4IajBUgdGvBC
4iMIxH5IVR+gMEmplwULB2sPfhBTvZM37NQMuZcG9LK+cs4GMzs9+TyEjk+I4TzA6JS9dON+
ZdRnEM37HP8JS612rdYufrAn3fenMBh4+AF7BMosZw5Dc6iHy/Fylp4MGJDSx1a0iAPSEl5h
SIhsixYfrdiA0AZENiCliweQT5kPShwprIp04gHKbomko/DsfwA4Io8qNgCx/ctxuP9lloPe
vfflmwSdApsfvnEdGsD7zpK1OVkk7mttr57D2LtUyoJFuzGTML4R1REK9JjFZL+IK7LsZIxv
1eENOpXf+RpuVJ2wMjPlO1ivOlJI6MchIwDYmraFST82oZswouAAeA4JwHKckWSi44gNt/rS
cMGu6+vI9ff7bH1os9Jyqb2x9BZHwysL+p3DeWefKwx3ew2e4dKdUT0bWKi/5QEhEZgyz64n
H+FtoZhOZXYsCYDP7WQn4pBlNyHxwBK2N/qQw3OJeYwDHlELDliLFHiWB/kqz16RcK2OnIgo
E0fc1AJExPyNQBpTZcVgXpFPv3lXeEiFR+GgIqlxICW6BgC+G6dUkrz3ybVmyIXhvVm+8lR5
7qHNzS6uS72NyIWxaWPaN4DEQF11SjBRR6Am9NdsEd82hveKQ968SjBZHErcQPXoQqbUflGC
Q88PyPxCLyCaTwBEdxY2N0TREAg8oianIRf79popwbxXPB9gGJAtjVC825bAAdsqYsQjkDpk
D+QngSk1mnvVPGFNMJNJHch7R5loWi90IuoJnzIpxsREAICfuOSsNc83e+ohsHhOHBKNi8M5
CAJ6BkiihCjK0LMAtlFk57vkReo4+4MEebx3eD420b4e1N+1tsWZXQ/ufjsAx65KB7j/06w4
kHNChIbJxKpAtaUb+8QwKNvcDRyymwPkgS69UzjgiO6UgFtrQVqWB3FLqocLltpejshsBz+l
N7QrW34dRtyQuN2ft0GxjCKy12ZF7npJkbjUVcHGxFyHWt0BiBOPnKQzkE+y27z1KVNurGS6
av680n3PI8U65PHeuBuu21x/cTEjbQ+7qb2kyEB2EY7QpwkSS+DQO2qZZVdKt3U25f1lVhuN
9ABHSUQ/UJg5BldzyLkhibe7XbxL/DhxCZ0fgdQKeAX1NQ7tjSjOQHZSgeBEo9+Wm4xNnIT6
ixAZjE5ksIiNJ/Li68qSHrDymjJRWXmWG5Yd86p1hKA9pHb+se0vbxzXlZ8yijAOBkE/MVnI
ctzrhYYxxdG7B7oF79WXoTNHUVbZpRmmY3eL/oz76a62xAalUlRZfRaPWf52EnztJnzBUKay
RIL5lLtpujxTdJeFWS0IVcm/XznkRG/n/J+dAqo1ocv0bsEx3A13VL1By3Wj2fofunP9QSKv
RQdlYepv8My87anYHzOb8PLNunwqBphZO1bpFncKw/ahrV8Dhx844xWaVn2hXsHNDGbhecdf
qi1ih2ymSjxRtBu2RJQNH4DYKyhfRRBiol4RLEMQvQx0jNUH6ULx9evz4/cr9vzy/Pj69erw
8Pjfby8PcnhkxbcwZsFmUy6JdEBTI+XdLH4qr687fr+xftJEtXxmr8KHc10ctQToF3MnvwXW
qHVTnjTaHPR3cb5LZ6cyKZPmhlrO1IX7Yk3Q3N/l4+uXq+/fnh6fPz8/XmHUxE3MmlNnzMKQ
KqcKGeS1/IXtOFvmsBWN40yO08LJW5WNHFnVZIy+xpaTHtFPbt5S+prC1huVWnyObgbtn//8
+vjjGbqkNZpDVZjBhpAGyjJpbo2geZfGqcyPVUVioXq0Ntu3fAD2YejR2wyePhu8JHYM+0aZ
hftzqppyVDx+b9B1I3wcKxmDxMLUIW/deEp+/6DlJu4klGs1Lixh4GnIcLb71HwBqPXH41uf
PlzEPPjprmdxJ7AyhPqnkRrRUl9hSteaQe0ikFObkz0/2Cj584WjJdPrOgI9lld5kx1s1KY+
Y3WuKNBIhYz6hrJrxLzE/P7hkp1vVkPrLVN8Vq/YoyGBqc5MttULC7T7GXzBqstiQ/ha9W56
1d4cMW5plLed4qUYAd3WCGlJ0reJfJW/EY2G5+TIsfVq84JyphpmSxs9oU5CNjj1yWRJYOtf
4pI2JlIlqWebcjiamuUGYmLkNETazlgGl8NMNSvKXAfp53K46Pn3eRXC8KGPEC/5wQ2c3flq
NlfSPjSw0ewn+m3pynlRYxFweh4OYWKT+vkmcQxJnU/hEJFbe0RZmesx5ZBaB3E0kosGa0PS
ExnHbu4T6HqelpkWeCo7jOG+8BbXMULvGtrnx7fXp5enxx9vsw7GLenqxf+y5Jd40z2QZWeu
Ws1RlcoN9ZS1vh+O6F4nIyOGIZtuFyhoaFig0kxzajTKc53Q4m2O2/fRrgENrzi8uJtBoFoN
Trdc6KwMnkufLM2CwArtLFpzFrZ+JRklmslSso4S7BH1BKq5KgMCs6ZqsDXcNYHjmx1MZoic
YLcHokf62CdGRtP6oT5Y6Wf3HMn9MEl3hNjSMbFwsppNo1VFicf/zqzaBi96mwTkee0M+vqs
NJtcaS81FyR0dkbRaje6JjuXR9zCdrQpEY+dwI3KNI8cfOge3x6+/YHj23ipkR2l+1L4ge/+
NMKgE+R7aiRoTxCQJKI4qjQlUign3HXnG42mvdRGUllVdV7SD1q5knAcpN3V7THDN6YGAZc7
0HUuDEOsr/kjyO7qAV9YdFSHKWQTfviBPhjrqWDK/gTpBQjmMlIvZlU2blhDmrEjfNOy+TGp
+lWkVwcSqg7oql4+31A+2HRZMUHnKKaqPrd3GTkwkXEYtJoey3biWzVLeRRstZx/+vr4+unp
DS2E/3h6+QZ/4WNFac+EycXb4thxIr244hFd45I3PQvDaeynARTtVH0mgPA5K+iugiD0XOgB
ehJBpT0lSHhe36gymOl4NNUPZxI7okeKLWzIcrxz9Y/sz0/Pr1f5a//2+vj0/fvr2z/hx9fP
z7//+faAO055wZ3zQ2XZ2q1O3eW2zC5WvE4tt0UI3h5JU2IOtXfHyhCyoELPy62ihm14qD53
mKkROYPOoB/JijoSL0WjSVY+XuED8pgdPT2ZCOw9fYBhoQIfxkYv1KHLryk3O7ymwruH6DUS
vc/EW0TeTsXz928vD39d9Q9fn160ns4Z8VloL5/ubMhvBegDgxM7bemEjl4NwQP/ZgwdNE63
t6PrVI4fnEzZzl8SDvcnFpVJltlEPfPCXNVPzQfXcc8uGx3XkqVgY07gD25Tkjoql+NyYKYI
ZdMlD2/Pn35/0uQjXM/XI/wxxiI0jTpfXtoDn6WLjFoqed+H2aAfTn4QGdLD2WACRSZSL3IR
hEkG/qsT2qBMcNSp441qnkPHrutDJvSPOIr1bEG9G6o+INWwZfrKits4lN/FawAsJMrOVoFl
FYkL8Jz3R2NO41E8oaCtTWjtyLRhNLLqoGcjHMoZ6kT19vDl6eo/f37+DNN7oTuwU7NZVh2+
BhGFgVUtbzFivTQ8gHbqhrq6V0iFHGkLfh+6DmO+slXtUdAc/qvqpjkrEc1mIO/6eyhTZgA1
ut4/NKoP3Bk7Y3CZeiwbvCydDvcDtZICH0bGJb+MAPllBOQvb0gFanJ9PE3lCdSpk1aoQzdc
zwg5tyML/M/k2HD43tCUW/ZaLbqeqU1QVuX5XBaT3D25XpJfDlqdYNCKF6VyedoMj21KMsDR
gb9dWB6xS2kwqKRQNNTSDHXDJTaI+Gdm1/xjcaFhHNxik/IlQsmwbz2tvECBtqy6qcCwaacT
NKlN1Pk9bFU8h1zeAIZxquWdwRQEUrdmWLdssIIgXZc6WQLogmNC+xaSaO5ToJ46Y2seLbxr
0BctAXMLfoJpK6w1pjuOqvpW7ThIULejC9EICrYAa7+hP1HHsukPEhLXJMA2ojKJekGaMnFC
1XAO2x62j02DflJPpA92zG3eJCktzLcvtidAK4O2f+TDCN+vWQTKNWBVepxkClWQ5VGniFbA
RvGUPjzcux51UiEwvccP95N9ACF6tPYhRN9pZ+br/dLHRcPCnN0KY14lASdatuUbji4tG3W2
q5n+e9Ke+y5UiyKOg9Q2Rk5lB6tDrbbezf1ZnYT9ohoNwlpW+UMcsFbytuuKrtMnhdsBVCX6
0BanYtD9SvtUlp3pKI18hrVmCqOqBb2ALiV3+qZUl1OmZiSIR5roqm3WsvyibnZwNi3oa3Ic
nQfYtIxDQJul43fmBz26KGFTcbHcvuPgLtEde9daKt4eoCFGtUIzjV/JHjU1acHMWYSH+WXX
Jfl6EVvt0k03buroIlnotpVuhlXpCqfM2iBRd0VIYrCSqLcbvGVil34YOM8HU5MXphaIxLzJ
GJv9JaqI6aFhy45OteGbo4rtDnorCz/I3C2usl7QufR31J58w/kDG6psfZukgTvdNbJn3w1m
GWznMvqb4rxy/7NFnyTqe08FikkIRBL5TmaFUhLpkzAcLYi4ESDqsNyU7NfCuGyX2tZiULF9
/Tb0nLjp6eSHInLJ4AGgsbFBCRIPWhFM7KR2e120ygkj7JGpQrHucpLtBPHn1DFm3C+pyIRO
sJuspnoYUzI8FcJPpErq89YgTGVTmMS6zFPZeTrSizYrT0eY2M18ztldW8sh5ZC4BKOfuqrC
00wV/S2T3S4ulDnwgBKjEzFWfriADqu+gJ4BPGtoqdhnTIgOj1jV3FrYDZ4R0nPDqnfM4gxq
xg3/m3p5REH1fGRB3p8yNIKARbKTOw8vWjbiLFOwX31Py1lMkxOsTTCJkF7GsYTnLp8qLdNb
vORlJQcro9Ibil5zbWVWg5evpCU1JcnxfCHUUPnLwrOC0c0mLf621MVQwPq3ur7xMQQCYtaG
AabgXSZ2yO7KXY45ToDOI3FkeRpD3y9kd3K8XiJEsEbErquSsqbreq396vM8vJSytEOf0TcW
oicKD99uFIaW9wyYR38JyJPBtSqz2wPFORsBLvaovzrqB2pGO+wTnUTpxsIXWvELP2SXjAiB
87rIdMfgM7VgPb8r0bsRYuU4WFL1GFu86fDO4mP5axSo5aKjuXOhdlqrojUNl4T6IGdGFnvL
nakT2ZaZ0kSGru9gDbknPipuFrQ24YZfRiElP4+1p/dA2T/k6l2eveZX4q7j8+vbVfX29PT9
8eHl6SrvL6vXuvz1y5fXrxLr6ze8AvlOJPm3Yogw1wCdf2fM5lpcYmKZxQ2fzENeAykcfVFX
phwRKuELJlK3I57oKs7sNuxIElG+sIbZse4y6MN4gfHYu2mg/YBnt77IzGszkYHSTLZODhKu
fLIG1Sa/Rjdc6JL8hGblmd7D2TC1VUMp3gtc90SaGgO9KH7n1i8LOzRGFWqB3kuKRymyuZvK
cICBX2Sx56a4oKaJH8YZnmHuJjgPXprsc90POfpsCKPAWRjN1tFYQ5ez7jWUqNTNfZPdlNY6
3zQ86kRk/fA4VP0Rj+BsegfPDO8j8O9+dWTL1yriQYY8uxHrGceK7OLG6gWUjMUO/YxoYbkJ
1NAgGz2SvRfJ9MAjP3YT+gntvW5lafLQdhKy8BxgH5KTCvsyUzM/bOT4XipAlFkARCVzFnhN
QGYFgPIcUgW0QBcKaM0usgAxWeTAU16IS3R5n6jQLeWNd4o7jokVsKbyg5TqADkL/cYnH2XO
HGI+MPMsFOPchYobOVuvL1nie0TRj0MbOYQcQOHIl52hMbZPHfoldnyigdapywKFDtGtOBI5
lIxa1iapG013ecFDaAzkG5GFG7QBN0qI6iAQp8SiOAN00wHoQ35EXRbEmi50vZ9WgE51bmCo
E2UHuh9QAuVTK0lOiZbGed0l2cOI/CxfMqg2QSSOdU/DGhM7Do1qZLAi9bHNQAW2I7R8WH2u
xHW1rZMv6pJRYsZaL3IM43yKL4C67VVryHxvJL8BSLg3mNkAO8GMUpgz5oXUNDhgmHPVMFSG
Ytfi6kTmsTzYWHmqLE3idKfYQ3Pre05W5x4x7Uog3Wgrg++OxPDbYApkfuZ5MaFe3LVJ6BJd
C+lqUEgZSfZaBxi0YzoZIe+dZAZqBHF6bMsysO1gF4aQrmAc2ioYx6QnhI0hoSZfQadbDy1D
HaLZkR7RxUsjUtlBhH7ZLTMQ0xbSE2JhP2WXJKH6wNBn6Eoo08cTvwDg51T/Y+xJthvHdf0V
L7sXfdrynHdXsiRbKouSIlEeaqPjSrlTPp3YuY5zXtf7+geQGjhAqV4lBiDOBEFiqkoexeY+
7NAkovBKEymeObM8YoEJTLVrsQCJpIVRoppcSARcszMTtjUeJusS9OznEsroFzuJE+8kVotV
FgQ/qi/pAViT9rIpCdVeoG+MeIK0m0A/PAjUgY0Xqhm4hGLurNnCcOMXGDcA7k/aGijvFfLJ
JfJtA+PQCC8X+V1YRp4HyZpTVxogy92d+mEZkuZDWF6njZFvDujceHwRzbFuI0jvTnigXs4E
zMvV+3kLqlYrA1rrXbQeCWBEv+YKfFFSS0KgSnxCsoYoiDfkpVwieZpZDZNB4k1YBL8OZule
mhduRMX7RGyWp360CfTUouIzYWTe85WXjRx1WQnYoXmO0sqBqV2nIgp9T1kBWjsb3QviQPNP
lLDUAHyFduugdcCWkcojBHClR9VFWJj2JPkWH8DmGOfmJ1CZlUZcRR8CvdrSQ1tHzyxm58ZG
NnANvT7kwrK7p5bIc31rQfJdlISk0Zdsd4KZDbT8AAiPPTNgJAID3wQk6dYYeOyXvakaaOV/
6UHAj0xhtS1cnX0E5iVbxkHm+iMLtX6YDCVQ1ZZFuzBASz09UZ02RsKkgqVlT5gCSXKwvI5V
dIROqumKm8PPUnwGCyhlkkCXMY+sHPGISeBEoY1tEJvmxgrVsJmboC9+nJJpfQVFkEB/VV90
CYUL3CExuF+GmRE9nwRKE08CThjwqeje8mCNFQYmht6IrPQmAg5312hrnnqea9QJDA4Gyxzf
2jy6Z3wKySvb4y85WGyoyIIArVXtkjmuNziHSONGQVEmWVxa3DBn9Ku02PqYXN0teplunela
LGKjnQwOdJAizBpV+Gebg0dbOtuNQKZZAcPQjw+Bu5BZHgUyLwtuauxUqDXomOh0B+LOWAfv
XOtE2EURS7kxFvsIlr0O+hrkqTk0Dayik1viVwcfhAKTa8qoMpiD2FoTEuNBz1JW/+oTA+Ks
laNQbUTKUoCo5SltDxkZzgWN4YPUZZWjyhUp7NRysZA09KI++2DEW+Y2CJSxsnSYyHAfglAb
enoVZrPdJAHu5AVVEuxq4xs7JxE7vz+dXjA8yPXjXQxVrS5SVUNYWhPXBg0rooLMoo5UPTp0
MQJ8bQGqXQh8JY4KbqOWsWB/Ba/XgoFeqdFaEYhcD68Qa4zgDAB7OK2x3GnpuBpI5S3dVQ9Y
D2shlhbmDPS6nIG+KSOLT2fz/XBoTVm1x1VBQzX36w5qaXsQFZDFCGiOZv0wgBXnBJZzXB0F
CLvUt1YTmnp6mpHuy5EzDLO6Kdr6wTDpzmyPKJLRNTTj2cikUShWMPNQhd3XlByBtG2v2ZMW
U5grIP28j2VXkdb2Il44zictzxfubDaFG57VyB3Z9HDnUtVgwzC8Sk8tZI8QKNISMGnj2S5d
6Wsy8F6O72SKOcFFPOrkQYwwTFEPHdEZ3xgvztqbZAJHyf8MxGDxFC4tweD76e10+f4+QH21
V0SDbx/3wTLeILeqCn/wevzZaLWPL+/XwbfT4HI6fT99/w+05aSVFJ5e3oSG+/V6Ow3Ol7+u
zZfY0ej1+Hy+PNeBZ4y9yXxPC2gBsCgzDBQkbEvNVAevZJbxBYFM4EAD0cvRUXVwI3W8Adpv
IS5aK2bUzylrY8GBd3oAkwZWlTH5mN3i68bIxDovxzsM5utg/fLRRC0YFNT5KT414gu18HRV
vy319gbIKE2kYJlhBGex6tqjQrWYcRqCGFSZo0EP0tyuDeyT/bAh1pYw1TGO6TbneZ2fXGcC
Elu/oPR0rCYyzXUVlBvlnrvsQ+absePMeqq2XzooKi8ck2+zCok4mMPA5WQjUE8lbeED+5ht
KsmAU+9plHzJqNiCRAcsC9YkZsXR1kzPQaegtxEtEiokUeY+kkVHeU+hgb8OzDAA/VQVt/ZC
0/aFMxr3rfaOZjqmx2wtzPfppmc7Gl6WJBxfo+B6i1lxPsP39KP5mmW/GOqGsCxcPexqHw1l
K91L6/6rEpe/2goKuUNHRu8hXtCaqb6id/+6b87D4+7XfQOqPnZuE08e/kWJQBTTukOVPiYt
ulSKdIm+wJ7FhGs883hV/nIjCK+NvhLSYj4n/YwNosVkSK5vti97uVbibpl1N5OoLB6Nh9bh
WiNTHs0WU0qHphA9em657yngsXRjvO/94tTIvGyxn5LtK9xV34mEqCpz4R7bJ5+2p1KQ5+4u
yoGzFwVdzYEtU/pY5FEPu18GuW5ZrmD3cNqljETtdj1TkWZ68FEVxZIoCejJxc+8tI+x7fFJ
oWK/YPS7qAiXaUIfzkVROkN60T3yUU+9lsDXyib67ZwUUgIWqZlIapCajEdI8X7JqZW3LYJ+
UTOPUtoXqxS37XXK9edtAbavLM1h7x3mHhnnTxJZufmE4Ob3vyiL+yDKA0FMPs2LfqMmyQfx
L3YPxqxEBfzZro0TMLaaz9GrKNhGy9yMFqS2M925OYyXJUPgvau39UFYBFxezVbRnpc9YaCk
BIvvwKtdL8EBvu47P4OvYqz2xjoJi8jDf8ZTVQGuYiYzVZ0uxidKNhUMZpCLdltzHbppsSFf
6kuvsCQjlzNy3Wc/fr6fn44vg/j4U8vkrl4/Q00Rl6SZAO+9INr2jIPMhWkkY+BuuE0R3Te1
+Cih21KKslwQ+PpYBaw58RJlPB3ADUw3SC93S+0H3vp1AD4OaFUDLHImi2FJVM20QILMM91D
sl2OjjmBRlcDzesIBt8Vamy9xHrS5dsh8/4s/D+R8tevYPhx4Ru9aYE9sW07vG53rHwX8xWj
i4Tbp5u7RU80B52Ok/k8OhpUCiaq82KHWuHf8VBH7ZaFb7aKRyuGrxp9rfkkXx2iveXcMWrB
cPuFb836tlyOhwZpWYSeCfHDaJansUGJ+nMebMxLvYoyNoveyzqiS/+EMq7IASxghmVGAzEC
CIs05cX9/PQ39VLVflQmQtSBA6fUPX6tUn69YpsyxcSxgmjiF6GyTKrxYk9g86mebadDdENM
jZFJVqoPeviYr+v3xLu3cLGlYJXQuDbDCHBq+AS563JnRGZlFOilx2aafW0HnZpQ4bOrGb90
YEoCaLAz1fBaAGVm7h6oGWwXUQRIRMGc2K0BMOnYWmOn0zZbiVXgdKomreqAY6KW6XT2SS2L
6dAuSY/Q2QAN++F6joMtpvqOaP/3brR6Qnm2BLMxJT0IdB13Ed1tS3ONZWpSZrki/JGWUUkA
GweRyWhILAs+npLJNqRGx3Mxoqj1FY+96YNDhswWeDvJaQPWY/e2K3P6j1VHyvuSDsmymvC9
fW3YcH80e7AGoxg7q3jsPOytCmvUSO+WsXXFO/e3l/Pl79+c34W8lK+XAg/ffGD+b8poa/Bb
p0v+veNycs5QrGNWa2Ts2b7OYaQ+o2dJ5M0Xy73Kbfjt/Pys8VVVT2cup0Z9Z3hJazi4exVh
ynuwjPs9mDAAaWapvWhqeDJwi0bhZZTUpZEQ7KdBNRpUwU7E+Jzf7sdvL6f3wV0OUjd/yen+
1/nljuEeRRzDwW84lvfj7fl0NyevHTO4qMD1Pfmk/S6MKqU60qgyN1FdL/CVF7MSRHHElTtU
gN4TcCNCbW/h5aqGVqAsfXYgXdjalgkqGRENF9qKdu8WVH3OygLJWFO01jLmz/WgvgIczPck
x6iRUzU+nYBFi9FiPs1s6MN8atGONWeAGjayYcHYsaH78cKkm07sb+e6YqptpH42CHC+GNHh
IevSidZOHaJGTZjMuVfJQGQKAHOTzRbOojJClCFOSCFEI3zm1kYJXVkdzI5OpeC29IsJUNjh
89BvXTr5atU0UWPwxpokQaw3wrhuICTVTOKEe6rPaB/qOswUoMmwq5gLxlczg2BY5hrSlvEI
ggcakUDNbM3oJ4SOhhreHRZpxkyvodq41oS0MBoWZd20doi9l/PpcleG2C0OCQj+e71X8EO9
LMLPZblSrEtqMvHtKtJ1acVOwCkj6XLfPed0I86wFV4U4fsT1QvuzDaqG2BpqJDQ4SaizbcQ
l/n5FrV6UU6FF0AKH6T2mkKrpXL1VBwIgnPTSwvyJQzrwqBDrQm2gkgCvtchWV5qb7QAYqvZ
aGJWGG4/UUluV+hnDGJuWfFDFijCqMDAPnlc+TrQIElS8bkBNe6PDQwDt/S1AtFMcxZowbCn
9hR47VuVMMNYq1kj+WO1PGR4JWJu4q51O39kB00sCKp5InBts5a35xusYvtZqg5va/a8hRIB
QHWaJUY/0N+na4wIwNL/IWParHTAJhpo1fHa2u7r6XZ9v/51H4Q/3063P7aD548TXIhth4Mm
0FRniietJIWHCW2zKAnqzpAkcJcAlkw/PYusYLXtDWW31hI2Dyb4pvY5QRZllHG8F+YpC9rK
lK0kMSlcDNyMq3E/WkSGlica02oy7BAxyw2KWHXMb4BZnvLUKm+zFOa8n8bq8+INGszAYG9K
pakhhv8AHEbVyFz1FJCXWsQ1y6EOGuG9XJ/+lkE///d6+7tbBd0XXWT+rqEdkkrSQtGJBCBU
VzqSIpqOVXdrHeVM+jCqK7SC8XwvmA9nvbiH0ZTGFRiEtFJDeqj1jVhW6D51CjbZZ5/3sc27
QaB2rKfUbE+LHSpJ5JEKVnWm0PlEmnQTSD4ywgdYSOAuILX/qiE1LZzP/54YpDvPoO6lDaNV
oXvW2DQBD/995Us/M4ilL1YT+rZ4O1/EJumYv9xAAlhcP25UYjOooMiFnD5VhBCABltuQsXP
CvPEaZTL2G8p2/bLwDJZ1BOYJJT3aDgDfkHAeNmT47eh4IyOhh/UkbfQ9Zd+E3ajeEkGV5Uy
h6sK2hLUXR1lto3T5XQ7Pw0EcpAd4QqMt2bbHk1+HaVqBNx0VRnCCQii0B3dvKqW2HVCBVgV
W0YjtEs9gV/FaZYdql0rQeen1+v99Ha7PlEPsXmA9vYYEMxagvnb6/uzuewKIPyt+Pl+P70O
UuDfP85vv3fpCH2duM1XiLGBiMqLMtlHVZG7jF4L6HlK3REycUyvchECTAr78udgfYU6Lld1
K9QomdhUOp6miR+ASKYImSoRyBJ4OLua+kUjQC20HghLReMzlZHqVPsaBMJoG5gtt7QBXSer
YKsloAz23OvedIJ/7ph1szatJRI+SXKR6xNNIqjreU2xz0bqM3AN1l+YaqCdSq1DjMfTKQW3
0qV1KHwh7W+YeWrVYHEdLTIGMnykJ9KqCXK+eJiPKem/JijYdKo+HdfgRnXbIeCylarOmZGK
jFCQLlcr9QGxg1XeUgdvREByLbAdguvXMBS9iLLkv2pAP+UbixR1UZh/XjzSSRIliiASFY2H
Bv2gICnqby3O4D49nV5Ot+vr6a4t2SVznYUaQJR5znRohltWobqLvO+O1M99d6xLOshJ/SHl
yiwxSlQXAXC0JyrFo0fWPaZu7qLrvKFw95Ex5C0OnW4M/GZf+A/GT72Hm733ZeMM1aBGDCQn
XZvrzifqBqoBVhoqAM9mZDor5i70XHMM9TGOmbRLQk2A2rS9NxkOpxpgNlLbVvANCOcjHbB0
hR+6XCqX48v1eXCHy+v5+Xw/vuD7MnCou8GkXH8+IlXigHhQg8xIJoXcTF0omLMTtqwGDZJt
AIch3kR54GlZpaXCSy8k5t5ookZFQBY3nmkzlY0nI6WziVvONdWTZFRtQ5Tb594ZUk9zmFbP
94YLR2nIdjVzhnrbuvyMNVyO7evbCxy7qlD44/QqzFiK0+X9aowwj6FpWUj4sXX73n3sSf22
/bpQZ0Hwmfoe2WRlN1Jk2xRNu8Pz97qBA6Cqr4K6i3+9TyU70xWiBppkgaxoWyV3jZRdiqyp
16yz3tn6RzSu7mZ9i/24mCsZJhpNK/1qYfFNv94CsBuOcl9om6Fd8dPhTLltwu+xyhbh92Qy
035PH0aoTlKdSAV0rIyLh4+GxktslvKexDxsNhqrWnDYDFNnrv9eqCpp2ByTuXqllctY1ijd
F2Guv3+8vv6sRcFm0a5up/9+nC5PPwfFz8v9x+n9/H+oPfT94s8sjvX7jhDNj/fr7U///H6/
nb991Nm2pBfJj+P76Y8YCE/fB/H1+jb4DUr4ffBXW8O7UkPzVTMrzz9v1/en69sJxsHaPUu2
dkhmqyzH9SFP4VBRxiQrx0M15EwNINeX/Jo8cASKOG8ivq61PXJfnY4v9x/K3m+gt/sgP95P
A3a9nO+acOyugslkqL3fogA3dIa270r48Xr+fr7/pIbHZSMjMUKzxEKuZkoKfQ+KVt2/eTFS
l5H8bZ51IVwXHfqOEM3hhCIqRsSoHZoIls0d9dOvp+P7x+30errcBx8wGsYkRzDJvRGtNmw/
o46oKNnizM7EzGqCoYro+FB8fv5xV0axGUMvg9NAVQy5/hdYXGN1AN14jMGdFEDmFw+awkxA
HnT13DJ05j3RfxFFRnHy2HjkqIHfEKDyBPg91g1QADKbTakxWmcjN4MJcYdDNfhqw2+LePQw
dDSfDQFzRnS2DVWWi3sd9iUBXG6VBfelcJ2RKrHkWT7UjGuaRpkJTWOea6YzsFFg7+jmJWnG
YS6oAcig2tEQkZpgEDlwjep5sd6Mx3TKW68YT9T3SAGY6zGi6k5wGMUpaQQtMAtt+gA0mY5p
P62psxipWhkvic3ObwMWz4Zzm3Ow4/PldJfXBZJ7bHoCWQmEcqa4m+HDg7od6rsEc9cJCTTy
4rpr2EzKVlFWCVIHPGUBBjAYm7aU4+loQk1FzaBFVTTvblphopsJCpk3Xagpkw2Eyjiiy9PL
+dI/jqpolHhxlLTd+XyHyJtglae8SUEqSm0saQZ/DN7vx8t3kFguJ7W+qAkYnJcZp26L6lCg
xYUirWlH79v1Dgz5bF0o/QLuk3qGdRAz6CXKsxiOrVFf0dADVYUcs+zBGXZnZ3Y7vePBQC7P
ZTacDRllELJk2Ui/8eJvfdVprEjzcQkz1Q6eZbHjTM3f1rUvi2ENk4nii+lM3Rvyt/U9QMd0
eut6xYpGkgR8OhlSrCTMRsOZ0uOvmQsHxcwCWIfgBX2k33V5Jbtd/zm/6nJGM2mR7+YY0yKo
tuqdc/8w7WaSn17fUEbUJ7Ppfbx/GM4cTeDhLBuSjwoc1qzK8MXvkcYaEk4bJm9ZYCoJm3NA
tV+EH3Jj6CD5yh7Gnu+ZahlE19cqunBhKbLi1kcyMzvZWIkuCtMigyCoFZe9VMKwc0EfaKKz
Ij89qStHf2qF02NC2UiEsa2SvPNjjzLMDqL5NMh7MYfGG7aerbNq6tEhbmGhB5gZACMVxbGu
n5c4l4dz2klT4pdBHvd4P0uCOPOcRU9mPUnBgqJHZy3xbWz2T2iK1MOY359RcDamNS41Hp/i
6U0f1WaZkvKTMr4eEjphhkTzYJ271TJjlI5yxfTsVsyrVu4moNXaiIWTZKs5yyNwlyNvCFCf
wcziCC255DfhYVB8fHsXOo2OUzQpG6TXT7OEwwNqQ6vRImHCZ6kHVRZLTRpbeqzaYHp6RCAp
tXehAA54kE6VA0XoGjzVQkUqe3I304IOMm9p9+x0w5gKx8vTafAqr362uUWuPqzzsEx8fGmK
W2WYe/l+u56/a+dh4udpRPuVJMD5yLREanZy+NFmPFHkXYYRK3MQRDwZ7IAupiFSrWsNSzg9
JKV8ZMDtoaXoVtR53ToxNpH89Hx7FapYS0UT+NphAD8xxxG1YJskujA4mrmRH8Qwl0tVW+j5
S1dTMPss6hlsjE1uWbKqOA+95pF5JEGVwA4OVhFsqzheStdY5a7lFVEVLVfoF5iQaX53lbda
m4eVCrXTAK/TdB0HbeebFbW+Xp9fTtSwKnY04ksYrf6lUGJnvEzn2ghD05QMGDcm0igI7QU/
Pd+Og7+a6o3HqDM0TfICVQ71YBCDapfiA6wwT1bGAI7FtMAM2J7CjYI9apRXhQ2plqhqr/TU
vBH0FsEyE257XUl8dAE99OBXhZll2TcBkQQ0pvPdQnclghjXxxKuAV0J4ieaAgpHTCHtrzTd
pojKU5PBNCdaEyXY8AqUQJ4HSimPK8arrWMCRsZXHlfG2C15uiomWpqrFfRUA3haaL10Cwe2
e9AoOhgcVH6EaZ8rP/r/xo5sN3Ic9yuFftoFdgapStKTPPSDbMtld/mKj1SSl0I6XZsEPUka
ObAzf78kJds6qOoBZpAukpJ1UiRFkZOOEt/ePeyt1Zl2tBx8fvu2//j+Aivrz723guZ8XLM8
hKBNwN5OSDx3zQ4TsMEMpmVd5daNBqFgoxdJKw1VeCPbysoCZu/fbFjDxEYMiD5jjCL9gREy
SfHWlZYm1NpL05utbkW1lg751zTtVixEL5AjD07n+XQdOo3cjAccZh7jV7Ii6+CgEe01W/5K
9D1/E6JIxoRMoBTrCAAcq1W0N44ruoIWN1waEYVrexXn2inSDhEbOhhkGmdEFQSZOd4aX9tP
URQSr9dNqO9FqCDU/Km/3IJUZNAfM02VW0txc/IPKon9YEYa05Qdp2ZrbCssqQ6YEnDkjbkE
mbKVaVGFH1OCsk+Pby9nZ6fnvy0/mWjMg0B77MSOM2/h/jjm3BVsEtNwZWGcMN0OjnOjc0hO
DxT/Zbus7J8OZhmumH1S6JAcBys+CWKCg/T5cxBzHsCcH4fKnB8Y8nPWc9EmsZPN2M1hLZdI
knc1rq/dWaBRy9VpaCoAtbRR9NrABo31L3nwigcfuz0ZESe8QG9Q8Hq9ScGZUUz8H3ybvNGd
usaZmyyCk8CYOOtqU+dnu5aBDe6n8WkK8E42wseIj2XRm8rfDAf5aLDjCE24thZ9frjaa0wr
bAcYH3FrIQFzoDDGGt5wJfMY45VwQv1EUQ1mEgVrFHI7LNeI64d244QOsGiGPvXvvzf71+f9
n4uH27sfj8/3s3BEiRzQBpQWYt257pg/Xx+f338sbp+/L74/7d/u/Sc9KmPprrfSRuhDBoOJ
F/JSFhPf/2OSX+CQws3mURhpICOMZqrrB2VNXLM9HqPQ8s/E4pennyAT/vb++LRfgDB59+ON
enOn4K9cBFyVVDWvUk58kBV6k5K0DYSYDFj00lZFFUU5dD0mFmC9/lI4TlUlX5ZHq5NZxW7z
BtgNWiZNma6VIqFKhRUHtwL5OtEhmmyJAIe23lbsjYDqniV3Sszd2anWWuovkXYglaMUBjIn
ZfzjbAMOiRqfuioMfYhiGW8FKCyq901NGo2pQJhwvx1pjbaHrRQb8q7jH+hSZHqUtc23WQZw
cuJV0/Tl6K+lPTAotpPLnBFEYpHsv33c31sbh8ZYXvWYD8B+xaPqQTzlN+UNslgaetrVVehp
zFwNzD9n2VAEdfQVBr/zG6ARMDdF6kYmYglTSyu0ceT33YWwKAqGcG080AILNxAmE+YSmMaA
8/7LZur9NTIMZ/q6QkRuUxC2K2DdGEtepculCS9lqZFOA0fMgelB+zAG7cCwtGGqS84sp1Hq
aar/ceX2usMcO8HCWb7OgI7tFrUM9eu0qLfeiPBIKk77FLs+sgO7ZKZePaqLPtwWC3T6+fip
+Gp2+3xv3hrV8WZoGC9ANAj7SIv1Yy7W0iRs8K06dxEYJN5dimKQZjrkmRZzT/zjil3iqeJp
bLAPoMBXGGOqs0ZNsZsJRVsJs8EuV0dMDyayxn6ZHyTRTVnOfdxeAJsFJpzUPGNRxVCtrhtW
UzTxbk8VcuzDBKao4v47bgV2j1IbjaFGAuneqbTaYrJK/NPU2TLYqo2UTYijjo9XQt/THBfY
YNn0niiBy3w+CBb/etOvg97+s3j6eN//tYd/7N/vfv/993/70kTbg0DQyys2w4XeWdBu+yWQ
ZgSqnM8htluFA/5Wb9HqGqyarJ50GFlWq0vGsIkAkGtsAI2Z2y6PUoHHMBGFJJzTZv09fAk0
HUzckNBXgSlgnLwxDhkrsRr2NVwnhGQ4uTo8Dsy6pthhLEzBZldSdPD/Jd7SdN5RaSc20Gsp
Z8Hd2oWQSThXR6zTsriVCeg2ueNspd4JxQMrm9DcAtKxeSog9LGRKLUWnOWuI9M90c2S2Dj0
9oTMl4xIDIeJFwHRwPOT6WJoLeMWtHPLHSRTysGXY7s9Prl7lP6CPIaFUA3chSnSo8QCK64o
Jl64Wjo14lIMlJYXXNALtasvtKDbhkTcca3sZNuSu9FXJX0be7vkiQwrcQqr4FB9hkoqe7zW
+QWVOuXMthgXHnmBIhg79ohUQm5YWCYaFZPuYgjF2CSiFPkhp2/ZrTN1IKMCm2bmJ2jldCTT
qVQBG6mKr50kZKOG1qnzZqzHi5ODgSwJZYlGsE3ToVKtOIxdt6LJeJpRL05HlhhG7rZ5n8Hg
mtxUfUehSxLNacFY2eCQBO9JaBcgJTEMt5JYF1S1OHy8JS8Tp4nqq7F9GLZ4bLjPs+h1HtFb
hxj8gXUA+xg6FvvjY1RFq24LhObNsFff6JDgVqQJ/XlNvXPImVDeCay9AEEzPUSihZNDJEpq
8gnGOdnCkvV6omdaz2bnzVJXicYOxOUgRpWcGUq5izCsboYnEOwkNbKzRG7i6Ko8cCdHaMxz
1OPZpctJ91pPUcGCHPHsGOmPHhpFkjqDozjApyLpvg41gDZr0aPbCzhkmnCcYAzi4R0bhotp
N3l6BpwEp024i4ArZaVoOeuTuf4nOus8NwhCjbYmWFZDCTu5GYP7OPtDjcj4rlNJLh/PZJPr
92/vSnaZe4FHMOWC6pxMDPP8zSwVhMig2BHhRbcnrSgJ9fPJIcsItSGTV8lQmquZhIOehieT
RePIa4TeAL5n38ATmuyZqVcqynsYPn5SET8MbApXwrWZ6DLnkbtqvwoGash/eSIp59Hy+PyE
Il1pMctwaxEkm4fz0ugI1sqv5ECDwxbbUpaBUSczD5zOohf41gtdmx1ZohP4ipx9dTDbLtaJ
dRuMv5kCU261IeoEHPeg2Pb5DTEPa7WMZsuRsKp31VBwPo2EN8v6NbMDoshEka+rEjbKAZrA
h6eugKCGsanyTp1rZqIvXLboXUEUM5j8jlkMhubRqg5ZH8xwM1K0xbW2zfPQXRKtLf2PIv30
uJ92rt8FQxPUv9qaVoe7p7XszG27pB5gayhjoVcCPTCKgY3DrINB9I7fOC6ziU/7Jz++9MOV
T/G1dkdXZ0ezkcTFwfQseZzaPV9WPBbPSFPdmbD4OV6ymCkCuScnCn/juhSVlRBhNHBZTTRb
p/VmusxBA1YgOksjgqEf0f2jxA2UVyA9WJKZqhw2jRkhQKvU5WxicBeilv9Z9aoZUKfEQ8KO
St3t7z5e0TeeuTLCzCr8tcjQ5v01RozryBeXtprF0DTJgdJW5AHlZHnVOyuSHGwrEIsGCjjX
XCt1SjhG15FFeuRmkzwkuxnVrM89NKNyutgvnyY3j7i9bvpJCohf//75/rK4wzxuL6+Lh/2f
P8kf0CKGrqytyDEWeOXD1W2DD/RJo2IT501mSsIuxi9kH6sG0CdtLa1kgrGE042G1/RgSzZN
w3QfnYAsF+jxG10glpRCJ/yNssbKOOGYpMbOQfZYONeaoWMFa7vgLsk7uu0hO6FX/Tpdrs7K
ofAQeE6yQH+48O7qYpCD9DD0J2GaXipMuPVi6DOQq/2pwXyHSnD0cF1e+qt2XQxSF0C+NW4b
8fH+gC+r7m7f998X8vkOtxH6Vf/v8f1hId7eXu4eCZXcvt962ymOS/9Dccl0NM4E/Lc6auri
ennMvvUdWy8v8kumBgnlgWX7rv8RvSl/evluxm8dPxv5Qxf3LddA1ng8fTvyqinarQdruO9d
McsNuPy2Je1Wxwl7ewj1oBR+lRkHvFIfdzt2WQo/KlTyeA/akv+xNj5eMSNGYHVi8EhuQBEO
I1LArgqPLFD1y6MkT/11xDLHcf1weynhXLgm5KnPUnJYUnAGlrnf5bZMlmbWAgNsv8meEatT
zm9qxh+vuIJdJrh3kDMWqvV3eCZOlz4DAvAx84l+3S7P2bh+mm81qjJ1jj7+fLCD0I2nnr+K
AbY7PfObh/AqD6wXUQ1RztTVxidM2yPQPdzsJt5KE6UsCjY9+0SBHjROCBIDxy0nhB+Y0IQZ
j5T++ps9EzeC4/6dKDrBZqSzCdhBHjkqV69k87VN2LaxbE02fNd1csV+sTezqo6wbY3TE4KH
Bn1En84nEfpX4fPdRzOiyzTYKVrHma7yntkaeXbCMabihveRnNEZE0bv9vn7y9Oi+nj6tn8d
A5hwTcVg+qCCcOJa0kZosqgGHpM5EbYtnGAVS5NEHWs+wgN+zftetqjoKGndF6Z2nIw8Inih
dcJ2sxjMyWlE0wZu1V06lLQPEWZbb55ijBDyXxJn3ijhxdvj/bN6Rkw+e9blJmkxGzNGo/ah
yW+Eay66xATBeIPFNkhhL7ua9dFTWHzwiz5HSS4qHdJ5/nCxHqzbzCivRHs92/j0a+tvr7ev
fy9eXz7eH59NYSHK+1ZiEGprj8xa2oznjJvUWfMV5nhLAUpmFYMGmLZ16STuMEkKWQWwMF4q
4rOPwidqaP1TJksfT3G6a+ud3YgKgmfYZMdKkfWDCNLnTZHbwnIM8mveW4wwtjMkI40ST9jN
B5/sh51dgRVahUQgznKgMUUey+iajWhsEpwwRUW7BY4Y2B1IEbHeXoAzk9jkkS/yxVYAFzEk
aMPA4URtUPRcTPjZ3C+qpC6NTjNNAK5sPj4xoIn04fSiJa9G/m9C51Nh7I79rMWAcjVf3SDY
/a2Vo9nGo6D0grfhXLs0QS4+nzDlROCZ/Yzus6HkjMqaAp0o/EZG8VcPZrtDzD3erW/yhkVc
3fibiDH2tBJ9p+qitk5yEwpcLT4LoOB7BiqKM+sHOXiP5rwZg3euncRVx8F2G/sqZYJHJQtO
OycMb3uJWWctJ1XkFcBXbBdIBFF2bovfkHnczFlB3mSgdq8rgZ4fxlhfmEy1qK3LBPx9aJ9U
Bb5rM75St4mpqSSJdchiogLQjjhdCzZLmti2QvTOKUIBoPHBen3wdqDDTgszr/iEovQBZAkH
5P8BlILqsKKpAQA=

--k+w/mQv8wyuph6w0--
