Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from intranet.asianux.com ([58.214.24.6]:15722 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab3ATKFF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2013 05:05:05 -0500
Message-ID: <50FBC180.2090003@asianux.com> (sfid-20130120_110525_369650_96D8BC75)
Date: Sun, 20 Jan 2013 18:05:52 +0800
From: Chen Gang <gang.chen@asianux.com>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: [suggestion]  drivers/net/wireless/iwlegacy: the parameter 'const
 char *buf' may be not '\0' base string for DINFO
Content-Type: text/plain; charset=GB2312
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Stanislaw, John

  we can not assume that the parameter 'const char *buf' is '\0' base string.
  and DINOF uses '%s' for buf (in line 3288..3289)
  so it will cause issue.

  I am not quite familiar with the detail features.
  so I send mail as a suggestion.
  please help checking, if this suggestion is valid, please help fixing, thanks.

  Regards

gchen.

3260 static ssize_t
3261 il3945_store_measurement(struct device *d, struct device_attribute *attr,
3262                          const char *buf, size_t count)
3263 {
3264         struct il_priv *il = dev_get_drvdata(d);
3265         struct ieee80211_measurement_params params = {
3266                 .channel = le16_to_cpu(il->active.channel),
3267                 .start_time = cpu_to_le64(il->_3945.last_tsf),
3268                 .duration = cpu_to_le16(1),
3269         };
3270         u8 type = IL_MEASURE_BASIC;
3271         u8 buffer[32];
3272         u8 channel;
3273 
3274         if (count) {
3275                 char *p = buffer;
3276                 strlcpy(buffer, buf, min(sizeof(buffer), count));
3277                 channel = simple_strtoul(p, NULL, 0);
3278                 if (channel)
3279                         params.channel = channel;
3280 
3281                 p = buffer;
3282                 while (*p && *p != ' ')
3283                         p++;
3284                 if (*p)
3285                         type = simple_strtoul(p + 1, NULL, 0);
3286         }
3287 
3288         D_INFO("Invoking measurement of type %d on " "channel %d (for '%s')\n",
3289                type, params.channel, buf);
3290         il3945_get_measurement(il, &params, type);
3291 
3292         return count;
3293 }
3294 




-- 
Chen Gang

Asianux Corporation
