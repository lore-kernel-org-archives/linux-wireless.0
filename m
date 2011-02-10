Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100Ab1BJHmp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 02:42:45 -0500
Date: Thu, 10 Feb 2011 08:41:40 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: =?utf-8?B?5p2O5pyd5piO?= <chaoming_li@realsil.com.cn>
Cc: "'Larry Finger'" <Larry.Finger@lwfinger.net>,
	"'John W Linville'" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	=?utf-8?B?J+WGr+aYpeeHlSc=?= <amyfcy_feng@realsil.com.cn>,
	=?utf-8?B?J+eGiuWFieWuiSc=?= <guangan_xiong@realsil.com.cn>
Subject: Re: =?utf-8?B?562U5aSN?= =?utf-8?Q?=3A?= about Mac80211 scan issue
Message-ID: <20110210074140.GA2228@redhat.com>
References: <4d4eec04.v8FQZqbn2LYPF8zs%Larry.Finger@lwfinger.net>
 <20110207151209.GG2319@redhat.com>
 <B84A4806C46340989E2A6AD2EB663300@realsil.com.cn>
 <20110209105405.GB5528@redhat.com>
 <B8DE8263FD784AC082CFDB7E9269BAEA@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <B8DE8263FD784AC082CFDB7E9269BAEA@realsil.com.cn>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 10, 2011 at 03:03:57PM +0800, 李朝明 wrote:
> > I'm not sure if I understand problem you described. Anyway, 
> > maybe is enaugh to implement ->flush() in rtlwifi to solve 
> > the problem?
> 
> I don't think drv_flush in ieee80211_start_sw_scan is needed, because
> there's no netif_tx_stop_all_queues before it.
> And on my test, all queues still send skb to driver in this drv_flush.

Hmm, there must be something wrong ... there is netif_tx_stop_all_queues
when interface is not MONITOR. Below are corresponding code snippets:

static void ieee80211_scan_state_leave_oper_channel(struct ieee80211_local *local,
                                                    unsigned long *next_delay)
{
        /* PS will already be in off-channel mode,
         * we do that once at the beginning of scanning.
         */
        ieee80211_offchannel_stop_vifs(local, false);

        /*
         * What if the nullfunc frames didn't arrive?
         */
        drv_flush(local, false);

....

void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
                                    bool offchannel_ps_enable)
{
        struct ieee80211_sub_if_data *sdata;

        /*
         * notify the AP about us leaving the channel and stop all
         * STA interfaces.
         */
        mutex_lock(&local->iflist_mtx);
        list_for_each_entry(sdata, &local->interfaces, list) {
                if (!ieee80211_sdata_running(sdata))
                        continue;

                if (sdata->vif.type != NL80211_IFTYPE_MONITOR)
                        set_bit(SDATA_STATE_OFFCHANNEL, &sdata->state);
...
                if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
                        netif_tx_stop_all_queues(sdata->dev);
              
