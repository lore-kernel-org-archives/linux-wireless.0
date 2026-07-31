Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680492D8DB5
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 13:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785503751; cv=fail; b=ar/53x1rJMD/bUjH68h3PDi1DKOpVgJpm5oMrHTi/8Ks4KPsEb0uBnZexZqpPiCIVYflgXYdK/Gxb9PTPO7R/HVncZBM4HDdgileELwO5bULI64mhfA5PAZbGq8eu7iO32UhZCG/bUWC+IFKhaidrgtpQpDbTlvMTWzF/sGcsNY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785503751; c=relaxed/simple;
	bh=4JszaJ/h+AOGub4VgNBFq0QhhgowXd2GVl+8hWethGI=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=G2P57nJWdIAqWy8y5qjn5gdoDoEaEIPr+1LPXbmpKD1KMDOSRLDDZkU+dGF1no53QYg5TCo7tPEPetJJ/6GaJaYM1ek49oG81p0lu7JPuKtEf4FHb9WwngkSEijS5ZrZrGqdbpFvapdHalvalC0eFTfYR0NmZYTAkrlk/e2R6ks=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R60cY/EI; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R60cY/EI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785503750; x=1817039750;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=4JszaJ/h+AOGub4VgNBFq0QhhgowXd2GVl+8hWethGI=;
  b=R60cY/EIE3dDzsI8Hc38xSSECV+c+5TGRgMeUfvWQcH/rtdz4UaHfUyV
   9bLmJ74M47BLEpEe28qogU+ZYpD4T8CJYXXiz+sENZKbNsAU0ddJOylLK
   R1dXEUQNr02vOUMkvBXeTQINmQPN/fHFUCnJG3SbOKGmg0adi/p+SsOWO
   OPc93zJQMXmk72iyDoB3cv5zb5iDfBumBo9t50mPWCPkkefbX3WbwafeL
   zl5+GS4jmfYIvgEJd0CdAvbWd2Al8GKlwLWnw+ZkRfW66D6Oq/zVtP3sX
   egU/QhaEZQe2bsc3jxOdJB9qe1seBadw2a1iHJZiHzkjzeU/Bupn43kKV
   w==;
X-CSE-ConnectionGUID: wvpJ27SUR4+P7f6sUd7dMQ==
X-CSE-MsgGUID: Ls/dqdwxTRKCZqg8XlYfmg==
X-IronPort-AV: E=McAfee;i="6800,10657,11860"; a="85895521"
X-IronPort-AV: E=Sophos;i="6.25,196,1779174000"; 
   d="scan'208";a="85895521"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2026 06:15:49 -0700
X-CSE-ConnectionGUID: WPbTd2l+R82fWabE3LMe6Q==
X-CSE-MsgGUID: LuBbbuY8QH6J44SqOM9kEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,196,1779174000"; 
   d="scan'208";a="265641696"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2026 06:15:48 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 31 Jul 2026 06:15:48 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Fri, 31 Jul 2026 06:15:48 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.18) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 31 Jul 2026 06:15:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B4AqUn9lmTAGD4aD6jC1UAr/gCyZdrbGzlBZ/YnG///q7dAqpagrWUCPl02BSwu2ecsWXirX8wy27CV7IHqFkhAnohf51oARXK61tKDSBuwAO04ZYTqUZGKqva+opTwx4dS7+JzOHibjXXoazLM2xSoEMzTUfQTszaN7TrcQhjh+2SeKJfcsZnc/Btw3UKlA6llGfWG9xcD5uf+tfWD5MXtBKO+j+THiD9+T1KQbknQyg+hbyhS1/iuz1muHVCZNcs0KzSQUu1fbdOTBThA2nyuyNy5DhU8QEPDpDwHAh3rMYSmrWUIyTYd6/kKME8qxzqlrwJgpFnwNWmby8gS9hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZegnDt4GNUkbCVEoF6St5e7VL9dSkZa6Cd6Jm0IVXu0=;
 b=kHTqvHHPjCwFspVwQxHLRpZzHr8tRmIdLwgjMuA1XIwuhcC4xUJE8CCOGb/93XrfvxjBbD5C25o5ZD+/OViGoRL+ZiV0GEaYXBbQLQ+9ri/tumqkth47ZC3Vk1r2pZkCOlh0XApq7oCfxO3bB6i4cCTE8z6D935wBYfj+EF/aXXuw1YuwbJ+r5Qfy1gPqB4SoTdZtG4S1XxfQECJJpJoZUwL0uB3zxkIJkMr5lVAZLip2Pn4vQHJ/9HzapHpaiDkHN0L2Qi96hA2rFf5BBkBooKF9jVEljoH47y92iesm5cjktNy0RklpH2MulqqE6+2YCv2Gdv5sNeYR2Qc1Wrt1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by CH3PR11MB7866.namprd11.prod.outlook.com (2603:10b6:610:124::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Fri, 31 Jul
 2026 13:15:44 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%5]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 13:15:43 +0000
Date: Fri, 31 Jul 2026 21:15:36 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Deepanshu Kartikey <kartikey406@gmail.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Johannes Berg
	<johannes.berg@intel.com>, <linux-wireless@vger.kernel.org>,
	<oliver.sang@intel.com>
Subject: [linux-next:master] [wifi]  dd40677999:
 hwsim.pmksa_cache_preauth_vlan_used.fail
Message-ID: <202607311514.d263d952-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: SI1PR02CA0021.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::14) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|CH3PR11MB7866:EE_
X-MS-Office365-Filtering-Correlation-Id: e926437c-5d56-465d-0d38-08deef05d36e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|10067099003|11063799006|56012099006|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info: 5NAwwgJ//DV91thuljiavB/20fKhKZwxCQHaL1RpzQu/axUr2CakK3ReyDNQ5Yo6FWgjHJ4cWZMm4kRknQLg0MajRpQKz8rnkilASMflln92e8qiZrjKpEDhLdSy5HhS4oPTmlrfxXxVfWXVP8TfFMrJbpoE0uC9X6pW/mdbXK6WjE6kdK6i6WmlD/l7LHtRx6FiuBOBNSC8kdNFcAUovVtN1lDkYrdFtBO/qWqZbcskRswOhTmbj6E03tn9QlmNwb0YVRYH0vndNzPh83XHGx67sTZo0Y3cNomeI/ARwdQRvTbG3+RquccTfKqwis6zH7I8NvAmmyDR9m2x0y4ty/Myk/o9IgFgBglsiLZ8ndSjNUGg5+WeNn37rukaRdbBrn6iPq/iOKwkn91uk5Z55FT8omfv4rkGp8ZIaXLCi80xp9Xear0fHht89GAtdp6rALUkSzyiFKZ5peplj5cmT+wMZCdb9Xshb+rB3DA2FIzJAj16SGWbxUcoCQYboLGIZ0EYEeMhhgXyuk93jSW6ynbAJ8gS0wagRZYXJQETY7ddmyC/UppdB4JyU+1FGkqzeEP0SZxR7EWmrmBTcBHILRo1BhNBGxTstQnjdzfVo4h+u2jmUs9s7KemcgPWNqgwtDe+HRKEH5TNu5A22BRFleekDVnIw0RQ3Pgw7qNdevM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(10067099003)(11063799006)(56012099006)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4/GKMVmma4SCzicVcpq5zhToLKEIJjz6sMgkPUx9jazdsHkvza0c7Q8Dl0np?=
 =?us-ascii?Q?+dJ5/OzysOOu3r9erdQW6NlYULQbYyGcXNEzvAJ6zroYWa6FF1DwJ6PLJl6E?=
 =?us-ascii?Q?38oiRSh2EQN5TafVk1TA98C6bMAB+2RwYa52TWOc+3HJQhb/sYuZXc35RPLs?=
 =?us-ascii?Q?65cbMzFMr8MJb50IurulPu7SKDZIm8FbCM+1ebSISleTpDST/GqtB9FzgWRy?=
 =?us-ascii?Q?i23oGDUK20XO/7wQShChz0degej6mupvF1dEB6nYlaMIWrgrAw0FQWVjAuZC?=
 =?us-ascii?Q?qirIz+95/Q3Xi1kLS3bhGr2plFo6IOCQAhY7OBb8/FuhWrLWCzGycaZzuAY6?=
 =?us-ascii?Q?Fyofn3hWiwL6W0lqP50CI7xWosaavEPtVrwp5XbPshjzmVkoT/kPLdaaGc47?=
 =?us-ascii?Q?upKlSgPAeEMMTTKt9SIGvU1mow4ZhEe1YbaIznh0GF2aexWmeocsiJNEd2pp?=
 =?us-ascii?Q?Zfhy1uRUtSZb0ZULhUWcO+Egv2YE0MiXf6l/7Vfa56OeLrg069QKutcgM8Eq?=
 =?us-ascii?Q?BPkmS5BcXU/9lhnINZj1kh5gZUzp5KNXs/PJX5piZBn9USicEFZWnzvw/Ewp?=
 =?us-ascii?Q?b2MrEs/xCEPgvqFbkED31qeP4FR0lgRzO2vMQhoh+Y6qc8+GyVFqPB++vsla?=
 =?us-ascii?Q?SER4cQkr5qcunbMsuU4PzBj4Loeu2eMt3msQ966zs2Jk714cEWcWpPvY8h4Z?=
 =?us-ascii?Q?Apu2L0vLiYxeuaHCc72wR1QQhvnANkwwIqFj4x0SwYM/hOH212FzVoIo3Z6v?=
 =?us-ascii?Q?QdxFKkDs4zHaabG95U6ukbMjQTS3kpBxZYLBf997O47rRIHlwYPUVji42+GG?=
 =?us-ascii?Q?w+UWo1/gIXuqCQ5MTfdI24FGnFnqKLBV0o+79enPPMTGe0uYmcN9hHx3T8rq?=
 =?us-ascii?Q?YNpXRJ7RwhXH/qxX4h12RNF5lhWwt5jaY8R4Y1A9FWSEWA3a8aTOO61cTOXa?=
 =?us-ascii?Q?3zqmamRtDL4SB2ROaAJhkIwQ2WAFFFg4l4uqKJaN373hvKjpAjBB/Lj0DyRK?=
 =?us-ascii?Q?1rU0bEAsL4WHYrI7QAbL6RD7UEsE/6a7+4L0of/WFQQ98+XUkeXb1zM8j6Fe?=
 =?us-ascii?Q?uLZgVXFHjamaFWiWe33DKKWp4A5nEjsAtQjjsyigGC1XyrJY9ll+sPrktwxm?=
 =?us-ascii?Q?pftos67FrVcoMhzBgSSZepI9+FOfBZVC3J//CLYQBiNf3C+hM7YolFoR3vIT?=
 =?us-ascii?Q?Z4sfDOZIlsBTPaSzn6Lhehextw8SW36kc3r9Rt2uxVL7cqiXCFiDX1aH2s6H?=
 =?us-ascii?Q?30ExdrlG3MT3u6jRJrmFA+QGb4Lc4Rf8urUEPaGurE6Yd4WshQp9kqKBTp9c?=
 =?us-ascii?Q?G2Xg+zO9u6VhpRkGHiEIukutYMy6+IBXpFMRt/vmwHJpmE2PFRoGYvjcB8Wd?=
 =?us-ascii?Q?t/PkSTLsJRvVKQ4nt6TFhE0XVu6zDg38X+nUpO2eSlzn0kOJeFND23YLCbF3?=
 =?us-ascii?Q?QD0mBJg23yDA4V+OOT3AtTA7DGd0fww4s8v7FaOF1hW4ETucrSQqFRXf4AIf?=
 =?us-ascii?Q?GSx+QCLY8GX84PGha9b0rX8cH9Fuughtn0Oq/SMmv9MqVTW+YY+Ji1NSc5tg?=
 =?us-ascii?Q?W3vNOXrgOYlm1krd5mFPiB5ICjDwINpPatoTxvaiv+45ISkWC/rsCGvBnHCe?=
 =?us-ascii?Q?Tedn8tbUhK5au2OxH5SFDoInT3WgXPyeiRmnY8OnhPht2tBDIeOJG+AK1fI0?=
 =?us-ascii?Q?UtfLbJPx7bwPqIJajoB5LlVIaHOhEf0mTo8fCPK3LaHY4VQhUHPZcD7wtdXu?=
 =?us-ascii?Q?PJSPhxik7Q=3D=3D?=
X-Exchange-RoutingPolicyChecked: qA6PB0lnh2C41GRgFrMHl0ccU65AjJVAx0+Gizq7bxTfA/t0AkeQeCgUZmW3ZtTJ7Go5nj/JHLCsM4LuNEdRJ4EOowWFYq9gsxGlaPRkdefSdmlRNCo8WcQba8A6Fnz15WQ8WKB9FqG5XlerBgNfX5MJ6uTNJYGSDqhYvQtpmEWdMKIPsnszT4eGQTJzbehMd8of/5+yAct4bRQFclOumowPO0JCjPV8sFV2LFe40ZWonpVq0mPIxfHw3sFld57UiyvQS9CGVJN2AiESipqllcTsQTHIvQbM3KOLhBl9s9VuEr25BKWM8QPYflrCpXG5yJ2ooc0Sjp592j2ooCH4TQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: e926437c-5d56-465d-0d38-08deef05d36e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 13:15:43.7342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pGwmiY+94NjK8bQ333+Wp+wKquxX5BpGl3J7AlPwa+v26hp28ml/XaafxTvb9RbxLUUkJi30T0eIiA4Hd5qrpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7866
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "hwsim.pmksa_cache_preauth_vlan_used.fail" on:

commit: dd406779999fa2065ec6b7c4f80906b727041d2c ("wifi: mac80211: don't encrypt pre-auth (ETH_P_PREAUTH) frames")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[test failed on linux-next/master 3652b49adac266a3d27cb41cdfdb7d8790fc3633]

in testcase: hwsim
version: hwsim-x86_64-890d573a1-1_20260621
with following parameters:

	test: group-31



config: x86_64-rhel-9.4-func
compiler: gcc-14
test machine: 16 threads Intel(R) Core(TM) i7-13620H (Raptor Lake) with 32G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202607311514.d263d952-lkp@intel.com


2026-07-29 04:48:06 ./run-tests.py pmksa_cache_preauth_vlan_used
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START pmksa_cache_preauth_vlan_used 1/1
Test: RSN pre-authentication to generate PMKSA cache entry (station with VLAN set)
Starting AP wlan3
Connect STA wlan0 to AP
Starting AP wlan4
Exception during test execution: No PMKSA cache entry created from pre-authentication
Traceback (most recent call last):
  File "/lkp/benchmarks/hwsim/tests/hwsim/./run-tests.py", line 635, in main
    t(dev, apdev)
    ~^^^^^^^^^^^^
  File "/lkp/benchmarks/hwsim/tests/hwsim/test_pmksa_cache.py", line 592, in test_pmksa_cache_preauth_vlan_used
    run_pmksa_cache_preauth_vlan_used(dev, apdev, None, force_disconnect=True)
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/lkp/benchmarks/hwsim/tests/hwsim/test_pmksa_cache.py", line 605, in run_pmksa_cache_preauth_vlan_used
    generic_pmksa_cache_preauth(dev, apdev, extraparams,
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^
                                "vlan1", "brvlan1",
                                ^^^^^^^^^^^^^^^^^^^
                                force_disconnect=force_disconnect)
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/lkp/benchmarks/hwsim/tests/hwsim/test_pmksa_cache.py", line 518, in generic_pmksa_cache_preauth
    raise Exception("No PMKSA cache entry created from pre-authentication")
Exception: No PMKSA cache entry created from pre-authentication
FAIL pmksa_cache_preauth_vlan_used 5.838044 2026-07-29 04:48:12.967860
passed 0 test case(s)
skipped 0 test case(s)
failed tests: pmksa_cache_preauth_vlan_used



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260731/202607311514.d263d952-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

