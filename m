Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35012 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab1BROfC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 09:35:02 -0500
Received: by wyb28 with SMTP id 28so3724623wyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 06:35:00 -0800 (PST)
Message-ID: <4D5E838F.1020707@lwfinger.net>
Date: Fri, 18 Feb 2011 08:34:55 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: John W Linville <linville@tuxdriver.com>, george0505@realtek.com,
	chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 13/14] rtlwifi: rtl8192cu: Add routine trx
References: <4d5d90c9.sN3PKFogcRQR8mbQ%Larry.Finger@lwfinger.net> <20110218112633.GA2270@redhat.com>
In-Reply-To: <20110218112633.GA2270@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/18/2011 05:26 AM, Stanislaw Gruszka wrote:
> On Thu, Feb 17, 2011 at 03:19:05PM -0600, Larry Finger wrote:
>> +static enum rtl_desc_qsel _rtl8192cu_mq_to_descq(struct ieee80211_hw *hw,
>> +					 u16 fc, u16 mac80211_queue_index)
>> +{
>> +	enum rtl_desc_qsel qsel;
>> +	struct rtl_priv *rtlpriv = rtl_priv(hw);
>> +
>> +	if (unlikely(ieee80211_is_beacon(fc))) {
>> +		qsel = QSLT_BEACON;
>> +		goto out;
>> +	}
>> +	if (ieee80211_is_mgmt(fc)) {
> [snip]
>> +	u16 fc = le16_to_cpu(hdr->frame_control);
>> +	enum rtl_desc_qsel fw_qsel = _rtl8192cu_mq_to_descq(hw, fc,
>
> We have that bug on all over the code, ieee80211_is_* expect le16 value
> whereas we pass cpu endian value. Driver is completely broken on that
> respect, it will not work on big endian machines.
>
> What should be done is use "sparse" (i.e. make C=1) and fix all
> endian bugs. That will not assure driver will work on BE machines,
> but at least we will fix obvious bugs.

Thanks for the comment. Unfortunately, sparse (C=2) does not find this error. 
That test had been done and was clean. After reading your comment, I went back 
to Documentation/sparse.txt and found the magic CF="-D__CHECK_ENDIAN__" 
argument. This argument results in multiple warnings that will be fixed for V2.

Do you have any suggestions regarding an inexpensive BE platform that I might 
acquire for testing? Ideally, this box would have the capability to support PCIe 
mini cards as well as USB.

Larry
