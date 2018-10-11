Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB0BEC32788
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 07:30:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4FAE2085B
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 07:30:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B4FAE2085B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbeJKO4w (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 10:56:52 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:54056 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbeJKO4w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 10:56:52 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gAVQf-00059q-Fw; Thu, 11 Oct 2018 09:30:41 +0200
Message-ID: <1539243027.3687.199.camel@sipsolutions.net>
Subject: Re: [RFC v3 01/12] rtw88: main files
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Tony Chuang <yhchuang@realtek.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
Cc:     "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date:   Thu, 11 Oct 2018 09:30:27 +0200
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D172DCB6@RTITMBSVM01.realtek.com.tw>
References: <1538565659-29530-1-git-send-email-yhchuang@realtek.com>
         <1538565659-29530-2-git-send-email-yhchuang@realtek.com>
         (sfid-20181003_132152_136031_D3015842) <201810081447.w98ElQfu018110@rtits1.realtek.com.tw>
         <F7CD281DE3E379468C6D07993EA72F84D172DCB6@RTITMBSVM01.realtek.com.tw>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2018-10-11 at 07:23 +0000, Tony Chuang wrote:

> > > +	switch (vif->type) {
> > > +	case NL80211_IFTYPE_AP:
> > > +	case NL80211_IFTYPE_MESH_POINT:
> > > +		net_type = RTW_NET_AP_MODE;
> > > +		break;
> > > +	case NL80211_IFTYPE_ADHOC:
> > > +		net_type = RTW_NET_AD_HOC;
> > > +		break;
> > > +	default:
> > > +		net_type = RTW_NET_NO_LINK;
> > 
> > you might to add STATION and then fail in the default case?
> 
> 
> Yeah, station starts with NO_LINK until it's associated with an AP

Right. I was just thinking of the switch statement - you might want to
handle STATION explicitly, instead of in the default case, and then fail
in the default case for this to be a little more readable and robust.
Not all that important.


> > This will provoke error messages to be printed for e.g. CMAC keys, or do
> > you really not support protected management frames? If you were to pick
> > "-EOPNOTSUPP" then no errors would be printed.
> 
> We do not support PMF hw encryption/decryption now, perhaps we need
> to register the cipher_schemes when ieee80211_register_hw.

Ok, that's fine.

> Even if HW does not support it, I think mac80211 can use SW encryption/decryption
> after driver failed to upload key to hardware?

Yes.

> So if driver has not declared MFP_CAPABLE, the mac80211 will ignore it and
> wpa_supplicant will guess we cannot perform MFP. It is strange.

Right, no, it's not strange. That was my point though, if you do want to
support it you should set MFP_CAPABLE, but you should return a different
error code to avoid an error message being printed from mac80211. That's
all. The logic is fine, just use -EOPNOTSUPP (rather than -ENOTSUPP) to
suppress any error messages.

> > why should statistics be reset evyer 2 seconds?
> 
> All of our statistics are counted in 2 seconds, ex. pkts, bytes, fa ...
> So just reset them every seconds.

No other device behaves this way though, so you shouldn't do this
either.

> > > +	ieee80211_hw_set(hw, MFP_CAPABLE);
> > 
> > so you do have MFP - I guess you should test it and check for spurious
> > hardware crypto messages
> 
> We don't have now, should remove them. But as I have mentioned, if we don't
> declare it here, mac80211 will discard the cipher and pass it to wiphy.
> And we still should be able to work with MFP because mac80211 can do
> software encryption/decryption for us.

Right. So this is fine, see above regarding the error message that gets
printed.

> Finally, I removed the vif_list and sta_list. And use the iterator
> provided by mac80211,
> But there is one question that how can we find all of the sta associated
> with specific vif,
> Has there an only way to iterate every sta and see if (sta->vif == vif) ?

Yes, looks like that's the only way - I guess you could pass the vif as
the data pointer. I suppose we could add a vif filter argument to the
iteration and ignore it if it's NULL, but is it worth it?

johannes
